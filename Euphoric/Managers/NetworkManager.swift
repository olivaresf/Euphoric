//
//  NetworkManager.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import Foundation
import FeedKit

enum ErrorManager:Error {
    case badRequest
}

struct SearchResults:Decodable {
    let resultCount:Int
    let results:[Podcast]
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
//        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: feedUrl) else { return }
        
//        print(secureFeedUrl)
        
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
