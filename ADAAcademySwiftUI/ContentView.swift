//
//  ContentView.swift
//  SwiftUITutorial
//
//  Created by Agatha Rachmat on 07/07/21.
//

import SwiftUI
import WidgetKit

struct ContentView: View {

    @StateObject var songModel = SongModel()
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiExample")) var songUserDefault : Data = Data()
    
    var body: some View {
        NavigationView(){
            VStack{
                HStack{
                    Button(action: {
                        songModel.isPlayingSomething.toggle()
                    }, label: {
                        if songModel.isPlayingSomething{
                            Image(systemName: "pause.circle.fill").font(.system(size: 56)).foregroundColor(.blue)
                        }else{
                            Image(systemName: "play.circle.fill").font(.system(size: 56)).foregroundColor(.green)
                        }
                        
                    })
                    Text(songModel.titleSongPlayed)
                }.frame(width: 350, height: 100, alignment: .leading)
                TextField("Siapa namamu?", text: $songModel.userName).padding()
                List(songModel.playlist){ i in
                    SongCellCustom(song: i, titleSongPlayed: $songModel.titleSongPlayed, isPlayingSomething: $songModel.isPlayingSomething)
                }
            }.navigationBarTitle(Text(songModel.userName)).foregroundColor(.gray)
        }.onAppear{
            guard let songData = try? JSONDecoder().decode(Song.self, from: songUserDefault)else{
                return
            }
            songModel.titleSongPlayed = songData.title + "-" + songData.singer
        }
    }
}

struct SongCellCustom : View {
    let song : Song
    
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiExample")) var songUserDefault : Data = Data()
    
    @Binding var titleSongPlayed : String
    @Binding var isPlayingSomething : Bool
    var body: some View{
        Button {
            titleSongPlayed = song.singer + " - " + song.title
            isPlayingSomething = true
            saveLastPlay()
        } label: {
            HStack{
                Text(song.singer + " - " + song.title)
                Spacer()
                Image(systemName: "play.circle.fill").font(.system(size: 30)).foregroundColor(.green)
            }
        }
    }
    
    func saveLastPlay(){
        guard let songData = try? JSONEncoder().encode(song) else {return}
        self.songUserDefault = songData
        print("Save",song)
        WidgetCenter.shared.reloadTimelines(ofKind: "SepotipaiWidget")
        
    }
}
