//
//  SongModel.swift
//  ADAAcademySwiftUI
//
//  Created by Local Administrator on 31/07/21.
//

import SwiftUI

struct Song: Identifiable {
    var id = UUID()
    var singer: String
    var title: String
    
}


class SongModel : ObservableObject{
    @Published var playlist = [Song]()
    
    @Published var lastSongPLayed : String = ""
    @Published var isPlayingSomething : Bool = false
    @Published var userName : String = ""
    
    init() {
        playlist = [
            Song(singer: "U2", title: "Elevation"),
            Song(singer: "Ciara", title: "Level up"),
            Song(singer: "Taftaf", title: "Senja di panggung Koplo"),
        ]
    }
    
}
