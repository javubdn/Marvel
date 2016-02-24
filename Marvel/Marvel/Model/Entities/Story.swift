//
//  Story.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Story {
	var id:Int64
	var descriptionStory:String
	var modified:NSDate
	var resourceURI:String
	var title:String
	var type:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	init() {
		id = 0
		descriptionStory = ""
		modified = NSDate()
		resourceURI = ""
		title = ""
		type = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
    /**
     *	This method gets a Story from a NSManagedObject
     */
    static func storyWithManagedObject(object:NSManagedObject)->Story {
        let story = Story()
        story.id = Int64((object.valueForKey("id") as! Int))
        story.descriptionStory = (object.valueForKey("descriptionStory") as? String)!
        story.modified = (object.valueForKey("modified") as? NSDate)!
        story.resourceURI = (object.valueForKey("resourceURI") as? String)!
        story.title = (object.valueForKey("title") as? String)!
        story.type = (object.valueForKey("type") as? String)!
        story.thumbnail = (object.valueForKey("thumbnail") as? String)!
        
        return story
    }
    
    /**
     *	This method gets an array of Stories from an array of NSManagedObject
     */
    static func getStoriesWithObjects(objects:[NSManagedObject])->[Story] {
        var stories:[Story] = []
        
        for(var i=0; i < objects.count; i++) {
            let newStory = Story.storyWithManagedObject((objects[i] as NSManagedObject))
            stories.insert(newStory, atIndex: i)
        }
        
        return stories
    }
	
    /**
     *	This method gets an NSManagedObject from a Story
     */
	static func managedObjectWithStory(story:Story)->NSManagedObject {
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		//We get the entity for type Character
		let entity =  NSEntityDescription.entityForName("Story", inManagedObjectContext:managedContext)
	 
		let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
	 
		object.setValue(NSNumber(longLong: story.id), forKey: "id")
		object.setValue(story.descriptionStory, forKey: "descriptionStory")
		object.setValue(story.modified, forKey: "modified")
		object.setValue(story.resourceURI, forKey: "resourceURI")
		object.setValue(story.title, forKey: "title")
		object.setValue(story.type, forKey: "type")
        object.setValue(story.thumbnail, forKey: "thumbnail")
		
		return object
		
	}
    
    /**
     *	This method an array of Stories from a dictionary (the one that comes from the Marvel's API)
     */
    static func getStoriesWithArrayDictionaries(objects:NSArray)->[Story] {
        var stories:[Story] = []
        
        for(var i=0; i < objects.count; i++) {
            let currentObject = objects[i]
            let newStory = Story()
            
            newStory.id = Int64(currentObject["id"] as! Int)
            if(currentObject["description"] != nil) {
                newStory.descriptionStory = (currentObject["description"] as? String)!
            }
            else {
                newStory.descriptionStory = ""
            }
            newStory.title = (currentObject["title"] as? String)!
            newStory.resourceURI = (currentObject["resourceURI"] as? String)!
            newStory.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            newStory.type = (currentObject["type"] as? String)!

            if(currentObject["thumbnail"] != nil){
                let path = (currentObject["thumbnail"]!!["path"] as? String)!
                let extensionImage = (currentObject["thumbnail"]!!["extension"] as? String)!
                newStory.thumbnail = "\(path).\(extensionImage)"
                DownloadManager.downloadImage(newStory, category: Constants.TypeData.Stories)
            }
            else {
                newStory.thumbnail = ""
            }
            stories.insert(newStory, atIndex: i)
        }
        
        return stories
    }
    
}