//
//  SepotipaiWidget.swift
//  SepotipaiWidget
//
//  Created by Local Administrator on 02/08/21.
//

import WidgetKit
import SwiftUI
import Intents


struct SepotipaiWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    @StateObject var songModel = SongModel()

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            Text("Coming Soon")
        default:
            Text("Coming Soon")
        }
    }
    
    var smallWidget : some View{
        VStack(alignment: .leading){
            Text("Last Played").font(.system(size: 12)).foregroundColor(.gray)
            HStack{
                VStack(alignment: .leading){
                    Text(entry.song.title).font(.system(size: 18)).bold()
                    Text(entry.song.singer).font(.system(size: 16))
                }
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
            }
        }
    }
    
    var mediumWidget : some View{
        VStack(alignment: .leading){
            HStack{
                VStack(alignment: .leading){
                    Text(entry.song.title).font(.system(size: 18)).bold()
                    Text(entry.song.singer).font(.system(size: 16))
                }
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
            }
            Divider()
            HStack( spacing: 20) {
                ForEach(songModel.playlist){song in
                    Text(song.singer)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        )
                }
            }
        }.padding(.horizontal)
    }
    
}

@main
struct SepotipaiWidget: Widget {
    let kind: String = "SepotipaiWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SepotipaiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sepotipai Widget")
        .description("This is sepotipai awesome widget.")
    }
}

struct Provider: IntentTimelineProvider {
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiUD")) var songData : Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), song: Song(singer: "", title: ""))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date(), configuration: configuration, song: lastPlaySong())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let entry = SimpleEntry(date: Date(), configuration: configuration, song: lastPlaySong())
        
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func lastPlaySong() -> Song {
        guard let lastPlay = try? JSONDecoder().decode(Song.self, from: songData) else{
            return Song(singer: "", title: "")
        }
        
        return lastPlay
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let song : Song
}
