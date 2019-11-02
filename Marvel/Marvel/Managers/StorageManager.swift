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
    func saveListItems(_ elements: [AnyObject], category: Constants.TypeData) {
        storageManagerSerialQueue.async(execute: {
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                var items = [NSManagedObject]()
                for element in elements {
                    var item: NSManagedObject
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
            }
        })
        
    }
    
    /**
     This method updates the max number of items that we have of a category
     
     - parameter category: category selected
     - parameter numItems: number max of items
     */
    func updateNumberItems(_ category: Constants.TypeData, numItems: Int) {
        let userDefaults = UserDefaults.standard
        switch category {
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
	func getData(_ category: Constants.TypeData) -> [NSManagedObject] {
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
		
		return items
	}
	
    /**
     This methods gets the items of the instance that we want (character, comic, etc...)
    
     - parameter category: type of data
     
     - returns: list of items
     */
    func getItems(_ category: Constants.TypeData) -> [ItemMarvel] {
		var items: [ItemMarvel]
        switch category {
        case .characters:
            items = CharactersFactory.getCharactersWithObjects(getData(category))
        case .comics:
            items = ComicsFactory.getComicsWithObjects(getData(category))
        case .creators:
            items = CreatorsFactory.getCreatorsWithObjects(getData(category))
        case .events:
            items = EventsFactory.getEventsWithObjects(getData(category))
        case .series:
            items = SeriesFactory.getSeriesWithObjects(getData(category))
        case .stories:
            items = StoriesFactory.getStoriesWithObjects(getData(category))
        }
        return items
    }
    
    /**
     This method gets the max number of items that we have of a category
     
     - parameter category: category
     
     - returns: number of items that we can have in this category
     */
    func getNumberItems(_ category: Constants.TypeData) -> Int {
        let userDefaults = UserDefaults.standard
        switch category {
        case .characters:
            return userDefaults.integer(forKey: "numberCharacters")
        case .comics:
            return userDefaults.integer(forKey: "numberComics")
        case .creators:
            return userDefaults.integer(forKey: "numberCreators")
        case .events:
            return userDefaults.integer(forKey: "numberEvents")
        case .series:
            return userDefaults.integer(forKey: "numberSeries")
        case .stories:
            return userDefaults.integer(forKey: "numberStories")
        }
    }
    
}
