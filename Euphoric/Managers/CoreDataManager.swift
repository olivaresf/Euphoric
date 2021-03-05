//
//  CoreDataManager.swift
//  Euphoric
//
//  Created by Fernando Olivares on 3/4/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton -> An instance of the object that can be accessed from anywhere
    static let shared = CoreDataManager()
    
    private init() {
        
    }
    
    // lazy -> initialized until it's actually being used
    // 👩🏻‍🎤
    // 🗒 -> viewContext (main thread/queue)
    // 📒 -> backgroundContext (backgound queue)
    lazy var persistentContainer👩🏻‍🎤: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "🎼")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // viewContext is displaying 100 podcasts
    // Podcast 🎸
    var viewContext🗒: NSManagedObjectContext {
        return persistentContainer👩🏻‍🎤.viewContext
    }
    
    // BG context is saving 10,000 podcasts
    // Podcast 🎸
    var backgroundContext📒: NSManagedObjectContext {
        return persistentContainer👩🏻‍🎤.newBackgroundContext()
    }
    
    func fetch() -> [Podcast] {
        
        let requestAllPodcasts: NSFetchRequest<CoreDataPodcast> = CoreDataPodcast.fetchRequest()
        do {
            // Fetch from the backing store 💼💿
            // 🎧 Transform from 💿 into 🎸 (which will be inside a context🗒)
            let coreDataPodcasts = try viewContext🗒.fetch(requestAllPodcasts)
            
            // Transform from 🎸 into 🎵 (which will be returned to the viewController)
            // $0 -> shorthand argument which accesses the first parameter in the map closure
            // The first parameter is a single object CoreDataPodcast 🎸
            let transformedPodcasts = coreDataPodcasts.map { Podcast(artworkURL: $0.artworkURL) }
            return transformedPodcasts
        } catch {
            print(error)
        }
        
        return []
    }
    
    // Podcast 🎵
    func save(podcasts: [Podcast]) {
        // No place where this string belongs.
        let nowhereMan = ""
        
        // 1. Transform the [Podcast] -> [NSManagedObjects] ([CoreDataPodcast])
        // 2. Insert them into the NSManagedObjectContext (sort of an array)
        // 3. Profit (Save them)
        //
        // Use the viewContext exclusively.
        // Stay in the main thread as long as possible.
        for podcast in podcasts {
            let transformedPodcast = CoreDataPodcast(context: viewContext🗒)
            
            // There exists one transformedPodcast in the viewContext.
            transformedPodcast.artworkURL = podcast.artworkUrl600
        }
        
        do {
            try viewContext🗒.save()
            
            // The save was successful.
            // 🎙 transformed from NSManagedObjects (🎸) into permanent records (💿)
            // 💼💿 -> backing store (SQLite, XML, Binary file)
        } catch {
            print(error)
        }
    }
}
