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
  
    @StateObject var songModel = SongModel()
    @Environment(\.widgetFamily)var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            smallWidget
        default:
            smallWidget
        }
        
    }
    
    var smallWidget : some View{
        VStack(alignment: .leading){
            Text("Last played")
                .foregroundColor(.gray)
                .font(.system(size: 15))
            
            HStack{
                VStack(alignment: .leading){
                    Text(entry.song.title)
                        .bold()
                        .font(.system(size: 20))
                    Text(entry.song.singer)
                        .font(.system(size: 18))
                }
                Button {
                    
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                }

            }
        }.padding(5)
    }
    
    var mediumWidget : some View{
        VStack(alignment: .leading){
            HStack{
                VStack(alignment: .leading){
                    Text(entry.song.title)
                        .bold()
                        .font(.system(size: 20))
                    Text(entry.song.singer)
                        .font(.system(size: 18))
                }
                Button {
                    
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                }
            }
            Divider()
            HStack( spacing: 10){
                ForEach(songModel.playlist){ song in
                    Text(song.singer)
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(.red)
                        )
                        
                }
            }.padding(10)
        }.padding(5)
    }
}

@main
struct SepotipaiWidget: Widget {
    let kind: String = "SepotipaiWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SepotipaiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sepotipai")
        .description("This is sepotipai awesome widget")
    }
}

struct Provider: IntentTimelineProvider {
    
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiExample")) var songUserDefault : Data = Data()
    
    func placeholder(in context: Context) -> SepotipaiEntry {
        SepotipaiEntry(date: Date(), configuration: ConfigurationIntent(), song: Song(singer: "", title: ""))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SepotipaiEntry) -> ()) {
        
        guard let songData = try? JSONDecoder().decode(Song.self, from: songUserDefault) else {return}
        
        let entry = SepotipaiEntry(date: Date(), configuration: configuration, song: songData)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SepotipaiEntry>) -> ()) {
        var entries: [SepotipaiEntry] = []

        guard let songData = try? JSONDecoder().decode(Song.self, from: songUserDefault) else {return}
        
        let entry = SepotipaiEntry(date: Date(), configuration: configuration, song: songData)
        
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SepotipaiEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var song : Song
}
