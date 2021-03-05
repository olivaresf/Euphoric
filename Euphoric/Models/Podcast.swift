//
//  Podcast.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import Foundation

class Podcast:NSObject, Codable, NSCoding {
    
    let trackName:String?
    let artistName:String?
    let artworkUrl600:String?
    let primaryGenreName:String?
    let trackCount:Int?
    let feedUrl:String?
    
    init(artworkURL: String?) {
        self.artworkUrl600 = artworkURL
        
        trackName = nil
        artistName = nil
        primaryGenreName = nil
        feedUrl = nil
        trackCount = nil
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        coder.encode(feedUrl ?? "", forKey: "feedKey")
        coder.encode(primaryGenreName ?? "", forKey: "primaryGenreName")
        coder.encode(trackCount ?? "", forKey: "trackCount")
    }
    
    required init?(coder: NSCoder) {
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = coder.decodeObject(forKey: "feedKey") as? String
        self.primaryGenreName = coder.decodeObject(forKey: "primaryGenreName") as? String
        self.trackCount = coder.decodeObject(forKey: "trackCount") as? Int
    }
    
    static func == (lhs: Podcast, rhs: Podcast) -> Bool {
        return true
    }

}
