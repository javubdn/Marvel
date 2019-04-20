//
//  StorageManager.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StorageManager {
	
	//This will be the instance for StorageManager, this is a Singleton class
	static let sharedInstance = StorageManager()
    let storageManagerSerialQueue = DispatchQueue(label: "com.jcr.StorageManager", attributes: [])
	
	// MARK: - Store methods
	
    /**
    This method saves the items of the given type in the database
    
    - parameter elements: list of elements to store
    - parameter category: type of items that we have (Character, comic, etc...)
    */
    func saveListItems(_ elements:[AnyObject], category:Constants.TypeData) {
        self.storageManagerSerialQueue.async(execute: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            var items = [NSManagedObject]()
            for element in elements {
                var item:NSManagedObject //= NSManagedObject()
                
                switch(category) {
                case .characters:
                    item = CharactersFactory.managedObjectWithCharacter(element as! Character)
                    break
                case .comics:
                    item = ComicsFactory.managedObjectWithComic(element as! Comic)
                    break
                case .creators:
                    item = CreatorsFactory.managedObjectWithCreator(element as! Creator)
                    break
                case .events:
                    item = EventsFactory.managedObjectWithEvent(element as! Event)
                    break
                case .series:
                    item = SeriesFactory.managedObjectWithSerie(element as! Serie)
                    break
                case .stories:
                    item = StoriesFactory.managedObjectWithStory(element as! Story)
                    break
                }
                items.append(item)
                
            }
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        })
        
    }
    
    /**
     This method updates the max number of items that we have of a category
     
     - parameter category: category selected
     - parameter numItems: number max of items
     */
    func updateNumberItems(_ category:Constants.TypeData, numItems:Int) {
        let userDefaults = UserDefaults.standard
        switch(category) {
        case .characters:
            userDefaults.set(numItems, forKey: "numberCharacters")
            userDefaults.synchronize()
            break;
        case .comics:
            userDefaults.set(numItems, forKey: "numberComics")
            userDefaults.synchronize()
            break;
        case .creators:
            userDefaults.set(numItems, forKey: "numberCreators")
            userDefaults.synchronize()
            break;
        case .events:
            userDefaults.set(numItems, forKey: "numberEvents")
            userDefaults.synchronize()
            break;
        case .series:
            userDefaults.set(numItems, forKey: "numberSeries")
            userDefaults.synchronize()
            break;
        case .stories:
            userDefaults.set(numItems, forKey: "numberStories")
            userDefaults.synchronize()
            break;
        }
    }
    
	// MARK: - Load methods
	
    /**
    This method gets the data from the database of the type that we are asking for
    
    - parameter category: category of the items that we want (Character, comic, etc...)
    
    - returns: Registers of the type of item that we want
    */
	func getData(_ category:Constants.TypeData)->NSArray {
		var items = [NSManagedObject]()
		
		//We need the managedContext
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: category.getTable())
		
		do {
			let results = try managedContext.fetch(fetchRequest)
			items = results as! [NSManagedObject]
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return items as NSArray
	}
	
    /**
     This methods gets the items of the instance that we want (character, comic, etc...)
    
     - parameter category: type of data
     
     - returns: list of items
     */
    func getItems(_ category:Constants.TypeData) -> [ItemMarvel] {
		
        var items: [ItemMarvel]
        
        switch(category) {
        case .characters:
            items = CharactersFactory.getCharactersWithObjects(self.getData(category) as! [NSManagedObject])
            for character in items {
                DownloadManager.downloadImage(character as! Character)
            }
            return items
        case .comics:
			items = ComicsFactory.getComicsWithObjects(self.getData(category) as! [NSManagedObject])
			for comic in items {
				DownloadManager.downloadImage(comic as! Comic)
			}
            return items
        case .creators:
			items = CreatorsFactory.getCreatorsWithObjects(self.getData(category) as! [NSManagedObject])
			for creator in items {
				DownloadManager.downloadImage(creator as! Creator)
			}
			return items
        case .events:
			items = EventsFactory.getEventsWithObjects(self.getData(category) as! [NSManagedObject])
			for event in items {
				DownloadManager.downloadImage(event as! Event)
			}
			return items
        case .series:
			items = SeriesFactory.getSeriesWithObjects(self.getData(category) as! [NSManagedObject])
			for serie in items {
				DownloadManager.downloadImage(serie as! Serie)
			}
			return items
        case .stories:
			items = StoriesFactory.getStoriesWithObjects(self.getData(category) as! [NSManagedObject])
			for story in items {
				DownloadManager.downloadImage(story as! Story)
			}
			return items
        }
    }
    
    /**
     This method gets the max number of items that we have of a category
     
     - parameter category: category
     
     - returns: number of items that we can have in this category
     */
    func getNumberItems(_ category:Constants.TypeData)->Int {
        let userDefaults = UserDefaults.standard
        switch(category) {
        case .characters:
            let numberCharacters = userDefaults.integer(forKey: "numberCharacters")
            return numberCharacters
        case .comics:
            let numberComics = userDefaults.integer(forKey: "numberComics")
            return numberComics
        case .creators:
            let numberCreators = userDefaults.integer(forKey: "numberCreators")
            return numberCreators
        case .events:
            let numberEvents = userDefaults.integer(forKey: "numberEvents")
            return numberEvents
        case .series:
            let numberSeries = userDefaults.integer(forKey: "numberSeries")
            return numberSeries
        case .stories:
            let numberStories = userDefaults.integer(forKey: "numberStories")
            return numberStories
        }
    }
    
}
