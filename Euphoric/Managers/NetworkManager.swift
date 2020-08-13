//
//  NetworkManager.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import Foundation

enum ErrorManager:Error {
    case badRequest
}

struct SearchResults:Decodable {
    let resultCount:Int
    let results:[Podcast]
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getPodcasts(for term:String, completed: @escaping (Result<[Podcast], ErrorManager>) -> ()){
        
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
