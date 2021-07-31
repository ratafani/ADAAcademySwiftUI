//
//  ContentView.swift
//  SwiftUITutorial
//
//  Created by Agatha Rachmat on 07/07/21.
//

import SwiftUI

struct Song: Identifiable {
    var id = UUID()
    var singer: String
    var title: String
    
}

struct ContentView: View {
    var playlist = [Song(singer: "U2", title: "Elevation"), Song(singer: "Ciara", title: "Level up")]
    
    @State private var titleSongPlayed : String = ""
    @State private var isPlayingSomething : Bool = false
    @State private var userName : String = ""
    
    var body: some View {
        NavigationView(){
            VStack{
                HStack{
                    Button(action: {
                        isPlayingSomething.toggle()
                    }, label: {
                        if isPlayingSomething{
                            Image(systemName: "pause.circle.fill").font(.system(size: 56)).foregroundColor(.blue)
                        }else{
                            Image(systemName: "play.circle.fill").font(.system(size: 56)).foregroundColor(.green)
                        }
                        
                    })
                    Text(titleSongPlayed)
                }.frame(width: 350, height: 100, alignment: .leading)
                TextField("Siapa namamu?", text: $userName).padding()
                List(playlist){ i in
                    SongCellCustom(song: i, titleSongPlayed: $titleSongPlayed, isPlayingSomething: $isPlayingSomething)
                }
            }.navigationBarTitle(Text(userName)).foregroundColor(.gray)
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
