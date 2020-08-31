//
//  Episode.swift
//  Euphoric
//
//  Created by Diego Oruna on 13/08/20.
//

import Foundation
import FeedKit

struct Episode: Hashable, Codable {
    var title: String
  let pubDate: Date
  let description: String
  var author: String
  var imageUrl: String?
  let streamUrl: String
  let summary:String
  var fileUrl: String?
  var htmlDescription:String?
  
  init(feedItem: RSSFeedItem) {
    self.title = feedItem.title ?? ""
    self.pubDate = feedItem.pubDate ?? Date()
    self.description = feedItem.iTunes?.iTunesSubtitle?.htmlToString ?? feedItem.description?.htmlToString ?? "No description provided"
    self.author = feedItem.iTunes?.iTunesAuthor ?? feedItem.author ?? ""
    self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    self.summary = feedItem.iTunes?.iTunesSummary?.htmlToString ?? ""
    self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    
    self.htmlDescription = feedItem.description ?? "No description provided"
  }
}


