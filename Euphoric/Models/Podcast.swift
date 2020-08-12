//
//  Podcast.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import Foundation

struct Podcast:Codable, Hashable {
    
    let trackName:String
    let artistName:String
    let artworkUrl600:String
    let primaryGenreName:String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackName)
    }
    
}
