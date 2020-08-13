//
//  Episode.swift
//  Euphoric
//
//  Created by Diego Oruna on 13/08/20.
//

import Foundation
import FeedKit

struct Episode: Codable, Hashable {
  let title: String
  let pubDate: Date
  let description: String
  let author: String
  var imageUrl: String?
  let streamUrl: String
  let summary:String
  var fileUrl: String?
  
  init(feedItem: RSSFeedItem) {
    self.title = feedItem.title ?? ""
    self.pubDate = feedItem.pubDate ?? Date()
    self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
    self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    self.summary = feedItem.iTunes?.iTunesSummary ?? ""
    self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
  }
}


