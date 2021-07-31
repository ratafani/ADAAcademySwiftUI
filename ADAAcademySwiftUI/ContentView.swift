//
//  ContentView.swift
//  SwiftUITutorial
//
//  Created by Agatha Rachmat on 07/07/21.
//

import SwiftUI


struct ContentView: View {
    @StateObject var songModel = SongModel()
    
    var body: some View {
        NavigationView(){
            VStack{
                playerView.frame(width: 350, height: 100, alignment: .leading)
                TextField("Siapa namamu?", text: $songModel.userName).padding()
                songListView
            }.navigationBarTitle(Text(songModel.userName)).foregroundColor(.gray)
        }
    }
    
    
    var playerView : some View{
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
            Text(songModel.lastSongPLayed)
        }
    }
    
    var songListView : some View{
        List(songModel.playlist){ i in
            SongCellCustom(song: i, titleSongPlayed: $songModel.lastSongPLayed, isPlayingSomething: $songModel.isPlayingSomething)
        }
    }
}

struct SongCellCustom : View {
    let song : Song
    
    @Binding var titleSongPlayed : String
    @Binding var isPlayingSomething : Bool
    var body: some View{
        Button {
            titleSongPlayed = song.singer + " - " + song.title
            isPlayingSomething = true
        } label: {
            HStack{
                Text(song.singer + " - " + song.title)
                Spacer()
                Image(systemName: "play.circle.fill").font(.system(size: 30)).foregroundColor(.green)
            }
        }
    }
}
