//
//  CoreDataManager.swift
//  Euphoric
//
//  Created by Fernando Olivares on 3/6/21.
//

import Foundation
import CoreData

class CoreDataManager {
	
	// A global instance of a class (CoreDataManager Apple)
	// A unique instance of a class (AppDelegate CS)
	static let shared = CoreDataManager() // singleton (Apple)
	
	init() {
		
	}
	
	// Main thread context
	// Serial queue -> one operation must finish before the next one begins.
	// If we were to fetch and save would happen one after the other.
	var context🗒 : NSManagedObjectContext {
		return persistentContainer👩🏼‍🎤.viewContext
	}
	
	// NSPersistentContainer
	lazy var persistentContainer👩🏼‍🎤: NSPersistentContainer = {
		// NOTE: The .xcdatamodel filename must be passed to the container.
		let container = NSPersistentContainer(name: "CoreDataModel🎼")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Unable to load persistent stores: \(error)")
			}
		}
		return container
	}()
	
	func save(podcasts: [Podcast]) {
		
		// An NSManagedObjectContext
		// 🗒 viewContext -> temporary reading/writing space
		for podcast in podcasts {
			let coreDataPodcast🎸 = CoreDataPodcast(context: context🗒)
			coreDataPodcast🎸.artworkURL = podcast.artworkUrl600
		}
		
		// Can I access the object before it is saved?
		// 🗒🔥
		// Object-graph persistence framework -> viewContext is where the objects live
		// persistentContainer👩🏼‍🎤.viewContext.reset()
		
		// It'll persist all the objects _inside_ the viewContext.
		// 🎸 (NSManagedObjects) inside 🗒 (NSManagedObjectContext) into 💿 (Persistent Store File Format)
		do {
			try context🗒.save()
		} catch {
			// Something went wrong transforming from 🎸 into 💿
		}
		
		
		// Insert the objects into the context
		// Persist the objects in the persistent store
	}
	
	func read() -> [Podcast] {
		
		// Read from the persistent store 💼💿
		// PersistentStoreCoordinator 🎙🎧
		// Insert objects 🎸 into the context 🗒
		// CoreDataPodcast request
		let allCoreDataPodcastFetchRequest: NSFetchRequest<CoreDataPodcast> = CoreDataPodcast.fetchRequest()
		
		do {
			// 1. 🗒 context receives a fetch request
			// 2. 🗒 context will pass the request to the persistent store coordinator 🎧🎙
			// 3. 🎙 transform the request into whatever language it needs to transform (SQLite)
			// 4. 🎙 will search the objects requested in the fetch 💼💿
			// 5. If the objects exist, 🎙 will transform the saved objects 💿 into managed objects 🎸
			// 5.1 It will insert the managed objects 🎸 into the context that requested them 🗒 (viewContext)
			let coreDataPodcasts🎸 = try context🗒.fetch(allCoreDataPodcastFetchRequest)
			
			// Transform the objects 🎸 into `struct Podcast`
			// $0 -> first parameter
			// if there is only one line we can ignore the `return` keyword
			let transformedPodcasts = coreDataPodcasts🎸.map { Podcast(artwork: $0.artworkURL) }
			return transformedPodcasts
		} catch {
			print("Oh no \(error)")
			return []
		}
	}
}
