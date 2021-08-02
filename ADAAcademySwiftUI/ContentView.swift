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
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiUD")) var songData : Data = Data()
    
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
            guard let lastPlay = try? JSONDecoder().decode(Song.self, from: songData)else{return}
            
            songModel.titleSongPlayed = lastPlay.singer + " - " + lastPlay.title
        }
    }
}

struct SongCellCustom : View {
    let song : Song
    
    @Binding var titleSongPlayed : String
    @Binding var isPlayingSomething : Bool
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiUD")) var songData : Data = Data()
    
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
        guard let lastPlay = try? JSONEncoder().encode(song) else {return}
        
        songData = lastPlay
        print("sudah tersimpan")
        
        WidgetCenter.shared.reloadTimelines(ofKind: "SepotipaiWidget")
    }
}
