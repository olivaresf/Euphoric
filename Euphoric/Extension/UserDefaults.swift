//
//  UserDefaults.swift
//  Euphoric
//
//  Created by Diego Oruna on 21/08/20.
//

import UIKit

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadedEpisodesKey = "downloadedEpisodesKey"
    static let listenedPodcastKey = "listenedPodcastKey"
    
    //MARK:- Episodes
    
    func deleteDownloadedEpisode(for episode:Episode){
        
        let episodes = downloadedEpisodes()
        
        let filteredEpisodes = episodes.filter { (e) -> Bool in
            return e.title != episode.title && e.author != episode.author
        }
        
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.setValue(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let err {
            print("Error deleting the episode", err)
        }
        
    }
    
    func downloadedEpisodes() -> [Episode] {
        
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodeErr {
            print("Failed to decode:", decodeErr)
        }
        
        return []
    }
    
    func downloadEpisode(episode: Episode) {
        do {
            var episodes = downloadedEpisodes()
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
            
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    func savedPodcasts() -> [Podcast]{
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        
        do {
            guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] else { return [] }
            return savedPodcasts
        } catch let err {
            print(err)
        }
        
        return []
    }
    
    func deletePodcast(_ podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        } catch let err {
            print("Error deleting podcast", err)
        }
        
    }
    
    //MARK:- Colors
    
    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
            }
        }
        return colorReturnded
    }
    
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch { print("Error UserDefaults") }
        }
        set(colorData, forKey: key)
    }
    
}
