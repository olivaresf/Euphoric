//
//  NetworkManager.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import Foundation
import FeedKit
import Alamofire

extension Notification.Name{
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

enum ErrorManager:Error {
    case badRequest
    case badUrl
}

struct SearchResults:Decodable {
    let resultCount:Int
    let results:[Podcast]
}

class NetworkManager {
    
    let baseUrl = "https://itunes.apple.com/search?explicit=Yes&term=podcast"
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl:String, episodeTitle:String)
    
    static let shared = NetworkManager()
    
    func downloadEpisode(episode:Episode){
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()

        AF.download(episode.streamUrl, interceptor: nil, to: downloadRequest).downloadProgress { (progress) in
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress":progress.fractionCompleted])
        }.response { (res) in
            
            let episodeDownloadComplete = EpisodeDownloadCompleteTuple(res.fileURL?.absoluteString ?? "", episode.title)
            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
            
            var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.author == episode.author}) else {return}
            
            downloadedEpisodes[index].fileUrl = res.fileURL?.absoluteString ?? ""
            
            do{
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.setValue(data, forKey: UserDefaults.downloadedEpisodesKey)
            }catch let err{
                print("Failed to encode downloaded episodes with file url update", err)
            }
            
        }

    }
    
    func fetchTopPodcastsByCountry(country:String = "PE", limit:Int = 10, completion: @escaping (Result<[Podcast], ErrorManager>) -> ()){
        
        guard let url = URL(string: baseUrl) else {
            completion(.failure(.badUrl))
            return
        }
        
        AF.request(url,parameters: ["limit":limit, "country":country]).response { (response) in
            
            guard let data = response.data else{
                completion(.failure(.badRequest))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let podcastResult = try decoder.decode(SearchResults.self, from: data)
                completion(.success(podcastResult.results))
            }catch let err{ print(err) }
            
        }
        
    }
    
    func fetchTopPodcasts(limit:Int = 10, completion: @escaping (Result<[Podcast], ErrorManager>) -> ()){
        
        guard let url = URL(string: baseUrl) else {return}
        
        AF.request(url, parameters: ["limit":"10"]).response { (response) in
            
            guard let data = response.data else {
                completion(.failure(.badRequest))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let podcastResult = try decoder.decode(SearchResults.self, from: data)
                completion(.success(podcastResult.results))
            }catch let err{ print(err) }
        }
        
    }
    
    func getPodcasts(for term:String, completion: @escaping (Result<[Podcast], ErrorManager>) -> ()){
        
        let baseUrl = "https://itunes.apple.com/search?explicit=Yes&media=podcast&term="
        guard let podcastUrl = URL(string: baseUrl + term) else {
            completion(.failure(.badUrl))
            return
        }
    
        AF.request(podcastUrl).response { (response) in
            
            guard let data = response.data else {
                completion(.failure(.badRequest))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResults.self, from: data)
                completion(.success(searchResults.results))
            }catch let err{ print(err) }
            
        }
    }
    
    func fetchEpisodes(feedUrl: String, all:Bool, completion: @escaping ([Episode], Int, String?) -> ()) {
        guard let url = URL(string: feedUrl) else { return }
        
        let parser = FeedParser(URL: url)
        
        DispatchQueue.global(qos: .background).async {
            parser.parseAsync { (result) in
                switch result {
                case .success(let feed):
                    guard let feed = feed.rssFeed else {return}
                    let numberOfItems = feed.items?.count ?? 0
                    if all{ completion(feed.toAllEpisodes(), numberOfItems, feed.description)
                    }else{ completion(feed.toFirst50Episodes(), numberOfItems, feed.description) }
                    
                    print("Sucessfully converted")
                case .failure(let error):
                    print("Error parsing the podcast", error)
                }
            }
            
        }
        
    }
    
}

extension RSSFeed {
    
    func toAllEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes: [Episode] = []
        
        var counter = 0
        
        for feedItem in items! {
            counter += 1
            print(counter)
            var episode = Episode(feedItem: feedItem)

            if episode.imageUrl == nil {
              episode.imageUrl = imageUrl
            }
            episodes.append(episode)
        }
        
        return episodes
    }
  
    
  func toFirst50Episodes() -> [Episode] {
    
    let imageUrl = iTunes?.iTunesImage?.attributes?.href
    
    var episodes: [Episode] = []
    
    var counter = 0
    
    for feedItem in items! {
        counter += 1
        print(counter)
        var episode = Episode(feedItem: feedItem)

        if episode.imageUrl == nil {
          episode.imageUrl = imageUrl
        }

        episodes.append(episode)

        if counter >= 50{
            print("reached 50")
            break
        }
        
    }
    return episodes
    
  }
  
}
