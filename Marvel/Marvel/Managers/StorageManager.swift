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
    let storageManagerSerialQueue = dispatch_queue_create("com.jcr.StorageManager", DISPATCH_QUEUE_SERIAL)
	
	// MARK: - Store methods
	
    /**
    This method saves the items of the given type in the database
    
    - parameter elements: list of elements to store
    - parameter category: type of items that we have (Character, comic, etc...)
    */
    func saveListItems(elements:[AnyObject], category:Constants.TypeData) {
        dispatch_async(self.storageManagerSerialQueue, {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            var items = [NSManagedObject]()
            for element in elements {
                var item:NSManagedObject //= NSManagedObject()
                
                switch(category) {
                case .Characters:
                    item = CharactersFactory.managedObjectWithCharacter(element as! Character)
                    break
                case .Comics:
                    item = ComicsFactory.managedObjectWithComic(element as! Comic)
                    break
                case .Creators:
                    item = CreatorsFactory.managedObjectWithCreator(element as! Creator)
                    break
                case .Events:
                    item = EventsFactory.managedObjectWithEvent(element as! Event)
                    break
                case .Series:
                    item = SeriesFactory.managedObjectWithSerie(element as! Serie)
                    break
                case .Stories:
                    item = StoriesFactory.managedObjectWithStory(element as! Story)
                    break
                    
                default:
                    continue
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
    func updateNumberItems(category:Constants.TypeData, numItems:Int) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        switch(category) {
        case .Characters:
            userDefaults.setInteger(numItems, forKey: "numberCharacters")
            userDefaults.synchronize()
            break;
        case .Comics:
            userDefaults.setInteger(numItems, forKey: "numberComics")
            userDefaults.synchronize()
            break;
        case .Creators:
            userDefaults.setInteger(numItems, forKey: "numberCreators")
            userDefaults.synchronize()
            break;
        case .Events:
            userDefaults.setInteger(numItems, forKey: "numberEvents")
            userDefaults.synchronize()
            break;
        case .Series:
            userDefaults.setInteger(numItems, forKey: "numberSeries")
            userDefaults.synchronize()
            break;
        case .Stories:
            userDefaults.setInteger(numItems, forKey: "numberStories")
            userDefaults.synchronize()
            break;
        default:
            break;
        }
    }
    
	// MARK: - Load methods
	
    /**
    This method gets the data from the database of the type that we are asking for
    
    - parameter category: category of the items that we want (Character, comic, etc...)
    
    - returns: Registers of the type of item that we want
    */
	func getData(category:Constants.TypeData)->NSArray {
		var items = [NSManagedObject]()
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		let fetchRequest = NSFetchRequest(entityName: category.getTable())
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			items = results as! [NSManagedObject]
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return items
	}
	
    /**
     This methods gets the items of the instance that we want (character, comic, etc...)
    
     - parameter category: type of data
     
     - returns: list of items
     */
    func getItems(category:Constants.TypeData)->NSArray {
		
        var items:NSArray
        
        switch(category) {
        case .Characters:
            items = CharactersFactory.getCharactersWithObjects(self.getData(category) as! [NSManagedObject])
            for character in items {
                DownloadManager.downloadImage(character as! Character, category: Constants.TypeData.Characters)
            }
            return items
        case .Comics:
			items = ComicsFactory.getComicsWithObjects(self.getData(category) as! [NSManagedObject])
			for comic in items {
				DownloadManager.downloadImage(comic as! Comic, category: Constants.TypeData.Comics)
			}
            return items
        case .Creators:
			items = CreatorsFactory.getCreatorsWithObjects(self.getData(category) as! [NSManagedObject])
			for creator in items {
				DownloadManager.downloadImage(creator as! Creator, category: Constants.TypeData.Creators)
			}
			return items
        case .Events:
			items = EventsFactory.getEventsWithObjects(self.getData(category) as! [NSManagedObject])
			for event in items {
				DownloadManager.downloadImage(event as! Event, category: Constants.TypeData.Events)
			}
			return items
        case .Series:
			items = SeriesFactory.getSeriesWithObjects(self.getData(category) as! [NSManagedObject])
			for serie in items {
				DownloadManager.downloadImage(serie as! Serie, category: Constants.TypeData.Series)
			}
			return items
        case .Stories:
			items = StoriesFactory.getStoriesWithObjects(self.getData(category) as! [NSManagedObject])
			for story in items {
				DownloadManager.downloadImage(story as! Story, category: Constants.TypeData.Stories)
			}
			return items
        default:
            return NSArray()
            
        }
    }
    
    /**
     This method gets the max number of items that we have of a category
     
     - parameter category: category
     
     - returns: number of items that we can have in this category
     */
    func getNumberItems(category:Constants.TypeData)->Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        switch(category) {
        case .Characters:
            let numberCharacters = userDefaults.integerForKey("numberCharacters")
            return numberCharacters
        case .Comics:
            let numberComics = userDefaults.integerForKey("numberComics")
            return numberComics
        case .Creators:
            let numberCreators = userDefaults.integerForKey("numberCreators")
            return numberCreators
        case .Events:
            let numberEvents = userDefaults.integerForKey("numberEvents")
            return numberEvents
        case .Series:
            let numberSeries = userDefaults.integerForKey("numberSeries")
            return numberSeries
        case .Stories:
            let numberStories = userDefaults.integerForKey("numberStories")
            return numberStories
        default:
            break;
        }
        return 0
    }
    
}
