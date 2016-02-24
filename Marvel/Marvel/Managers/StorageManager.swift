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
	
	// MARK: - Store methods
	
	func saveCharacter(character:Character) {
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		let item = Character.managedObjectWithCharacter(character)
		var items = [NSManagedObject]()
		
		do {
			try managedContext.save()
			items.append(item)
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		}
		
	}
	
	func saveCharactersList(characters:[Character]) {
		
		for character in characters {
			saveCharacter(character)
		}
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
                DownloadManager.downloadImage(character as! Character)
            }
            return items
        case .Comics:
            return Comic.getComicsWithObjects(self.getData(category) as! [NSManagedObject])
        case .Creators:
            return Creator.getCreatorsWithObjects(self.getData(category) as! [NSManagedObject])
        case .Events:
            return Event.getEventsWithObjects(self.getData(category) as! [NSManagedObject])
        case .Series:
            return Serie.getSeriesWithObjects(self.getData(category) as! [NSManagedObject])
        case .Stories:
            return Story.getStoriesWithObjects(self.getData(category) as! [NSManagedObject])
        default:
            return NSArray()
            
        }
    }
    
    func updateNumberItems(category:Constants.TypeData, numItems:Int) {
        switch(category) {
        case .Characters:
            break;
        default:
            break;
        }
    }
    
}
