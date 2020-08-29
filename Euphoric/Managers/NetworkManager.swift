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
}

struct SearchResults:Decodable {
    let resultCount:Int
    let results:[Podcast]
}

class NetworkManager {
    
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
        
        let baseUrl = "https://itunes.apple.com/search?explicit=Yes&term=podcast&limit=\(limit)&country=\(country)"
        
        guard let url = URL(string: baseUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            if let _ = err {
                completion(.failure(.badRequest))
            }
            
            guard let data = data, let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let podcastResult = try decoder.decode(SearchResults.self, from: data)
                
                completion(.success(podcastResult.results))
                
            }catch let err{
                print(err.localizedDescription)
            }
            
        }.resume()
        
    }
    
    func fetchTopPodcasts(limit:Int = 10, completion: @escaping (Result<[Podcast], ErrorManager>) -> ()){
        
        let baseUrl = "https://itunes.apple.com/search?explicit=Yes&term=podcast&limit=10"
        
        guard let url = URL(string: baseUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            if let _ = err {
                completion(.failure(.badRequest))
            }
            
            guard let data = data, let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let podcastResult = try decoder.decode(SearchResults.self, from: data)
                
                completion(.success(podcastResult.results))
                
            }catch let err{
                print(err.localizedDescription)
            }
            
        }.resume()
        
    }
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        #warning("Implement incremental loading")
        
        guard let url = URL(string: feedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            
            let parser = FeedParser(URL: url)
            parser.parseAsync(result: { (result) in
                
                switch result {
                case .success(let feed):
                    guard let feed = feed.rssFeed else {return}
                    completionHandler(feed.toEpisodes())
                case .failure(let error):
                    print("Error parsing the podcast", error)
                }
            })
        }
        
    }
    
    func getPodcasts(for term:String = "Joe Rogan", completed: @escaping (Result<[Podcast], ErrorManager>) -> ()){
        
        let baseUrl = "https://itunes.apple.com/search?explicit=Yes&media=podcast&term="
        guard let podcastUrl = URL(string: baseUrl + term) else { return }
        
        URLSession.shared.dataTask(with: podcastUrl) { (data, res, err) in
            
            #warning("Improve error handling")
            
            if let _ = err {
                completed(.failure(.badRequest))
            }
            
            guard let data = data, let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completed(.failure(.badRequest))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResults.self, from: data)
                
                completed(.success(searchResults.results))
                
            }catch let err{
                print(err.localizedDescription)
            }
            
        }.resume()
    }
}

extension RSSFeed {
  
  func toEpisodes() -> [Episode] {
    
    let imageUrl = iTunes?.iTunesImage?.attributes?.href
    
    var episodes: [Episode] = []
    
    items?.forEach({ (feedItem) in
        var episode = Episode(feedItem: feedItem)
        
        if episode.imageUrl == nil {
          episode.imageUrl = imageUrl
        }
        
        episodes.append(episode)
        
    })
    
    return episodes
    
  }
  
}
