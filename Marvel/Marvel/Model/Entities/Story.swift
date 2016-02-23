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
	
	init() {
		id = 0
		descriptionStory = ""
		modified = NSDate()
		resourceURI = ""
		title = ""
		type = ""
	}
    
    static func storyWithManagedObject(object:NSManagedObject)->Story {
        let story = Story()
        story.id = Int64((object.valueForKey("id") as! Int))
        story.descriptionStory = (object.valueForKey("descriptionStory") as? String)!
        story.modified = (object.valueForKey("modified") as? NSDate)!
        story.resourceURI = (object.valueForKey("resourceURI") as? String)!
        story.title = (object.valueForKey("title") as? String)!
        story.type = (object.valueForKey("type") as? String)!
        
        return story
    }
    
    static func getStoriesWithObjects(objects:[NSManagedObject])->[Story] {
        var stories:[Story] = []
        
        for(var i=0; i < objects.count; i++) {
            let newStory = Story.storyWithManagedObject((objects[i] as NSManagedObject))
            stories.insert(newStory, atIndex: i)
        }
        
        return stories
    }
	
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
		
		return object
		
	}
}