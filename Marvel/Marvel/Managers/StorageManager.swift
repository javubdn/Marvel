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
	
//	func saveData(data:AnyObject, category:Constants.TypeData) {
//        
//        //We need the managedContext
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        var item:NSManagedObject //= NSManagedObject()
//        
//        switch(category) {
//        case .Characters:
//            item = Character.managedObjectWithCharacter(data as! Character)
//            break
//        case .Comics:
//            item = Comic.managedObjectWithComic(data as! Comic)
//            break
//        case .Creators:
//            item = Creator.managedObjectWithCreator(data as! Creator)
//            break
//        case .Events:
//            item = Event.managedObjectWithEvent(data as! Event)
//            break
//        case .Series:
//            item = Serie.managedObjectWithSerie(data as! Serie)
//            break
//        case .Stories:
//            item = Story.managedObjectWithStory(data as! Story)
//            break
//            
//        default:
//            return
//        }
//        
//        var items = [NSManagedObject]()
//        
//        do {
//            try managedContext.save()
//            items.append(item)
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//    }
//    
//    func saveListItems(items:[AnyObject], category:Constants.TypeData) {
//        dispatch_async(self.storageManagerSerialQueue, {
//            for item in items {
//                self.saveData(item, category: category)
//            }
//        })
//        
//    }
    
    func saveListItems(elements:[AnyObject], category:Constants.TypeData) {
        dispatch_async(self.storageManagerSerialQueue, {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            var items = [NSManagedObject]()
            for element in elements {
                var item:NSManagedObject //= NSManagedObject()
                
                switch(category) {
                case .Characters:
                    item = Character.managedObjectWithCharacter(element as! Character)
                    break
                case .Comics:
                    item = Comic.managedObjectWithComic(element as! Comic)
                    break
                case .Creators:
                    item = Creator.managedObjectWithCreator(element as! Creator)
                    break
                case .Events:
                    item = Event.managedObjectWithEvent(element as! Event)
                    break
                case .Series:
                    item = Serie.managedObjectWithSerie(element as! Serie)
                    break
                case .Stories:
                    item = Story.managedObjectWithStory(element as! Story)
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
	// MARK: - Load methods
	
	func getData(category:Constants.TypeData)->NSArray {
		var stories = [NSManagedObject]()
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		let fetchRequest = NSFetchRequest(entityName: category.getTable())
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			stories = results as! [NSManagedObject]
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return stories
	}
	
    func getItems(category:Constants.TypeData)->NSArray {
		
        var items:NSArray
        
        switch(category) {
        case .Characters:
            items = Character.getCharactersWithObjects(self.getData(category) as! [NSManagedObject])
            for character in items {
                DownloadManager.downloadImage(character as! Character, category: Constants.TypeData.Characters)
            }
            return items
        case .Comics:
			items = Comic.getComicsWithObjects(self.getData(category) as! [NSManagedObject])
			for comic in items {
				DownloadManager.downloadImage(comic as! Comic, category: Constants.TypeData.Comics)
			}
            return items
        case .Creators:
			items = Creator.getCreatorsWithObjects(self.getData(category) as! [NSManagedObject])
			for creator in items {
				DownloadManager.downloadImage(creator as! Creator, category: Constants.TypeData.Creators)
			}
			return items
        case .Events:
			items = Event.getEventsWithObjects(self.getData(category) as! [NSManagedObject])
			for event in items {
				DownloadManager.downloadImage(event as! Event, category: Constants.TypeData.Events)
			}
			return items
        case .Series:
			items = Serie.getSeriesWithObjects(self.getData(category) as! [NSManagedObject])
			for serie in items {
				DownloadManager.downloadImage(serie as! Serie, category: Constants.TypeData.Series)
			}
			return items
        case .Stories:
			items = Story.getStoriesWithObjects(self.getData(category) as! [NSManagedObject])
			for story in items {
				DownloadManager.downloadImage(story as! Story, category: Constants.TypeData.Stories)
			}
			return items
        default:
            return NSArray()
            
        }
    }
    
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
