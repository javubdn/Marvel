//
//  StoriesFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class to create the instances of Story
class StoriesFactory {
    
    /**
     This method gets a Story from a NSManagedObject
     
     - parameter object: Register we use to create the serie
     
     - returns: Story with the data of the register
     */
    static func storyWithManagedObject(_ object:NSManagedObject)->Story {
        let story = Story()
        story.id = Int64((object.value(forKey: "id") as! Int))
        story.descriptionStory = (object.value(forKey: "descriptionStory") as? String)!
        story.modified = (object.value(forKey: "modified") as? Date)!
        story.resourceURI = (object.value(forKey: "resourceURI") as? String)!
        story.title = (object.value(forKey: "title") as? String)!
        story.type = (object.value(forKey: "type") as? String)!
        story.thumbnail = (object.value(forKey: "thumbnail") as? String)!
        
        return story
    }
    
    /**
     This method gets an array of Stories from an array of NSManagedObject
     
     - parameter objects: array of registers to get the stories
     
     - returns: list of stories
     */
    static func getStoriesWithObjects(_ objects:[NSManagedObject])->[Story] {
        var stories:[Story] = []
        
        for object in objects {
            let newStory = storyWithManagedObject(object as NSManagedObject)
            stories.append(newStory)
        }
        
        return stories
    }
    
    /**
     This method gets an NSManagedObject from a Story
     
     - parameter story: Story to get the register
     
     - returns: Register to store with the data of the story
     */
    static func managedObjectWithStory(_ story:Story)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Story", in:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(NSNumber(value: story.id as Int64), forKey: "id")
        object.setValue(story.descriptionStory, forKey: "descriptionStory")
        object.setValue(story.modified, forKey: "modified")
        object.setValue(story.resourceURI, forKey: "resourceURI")
        object.setValue(story.title, forKey: "title")
        object.setValue(story.type, forKey: "type")
        object.setValue(story.thumbnail, forKey: "thumbnail")
        
        return object
        
    }
    
    /**
     This method an array of Stories from a dictionary (the one that comes from the Marvel's API)
     
     - parameter objects: list of items that we obtain from the call to the Marvel API
     
     - returns: array of stories
     */
    static func getStoriesWithArrayDictionaries(_ objects:[[String: Any]])->[Story] {
        var stories = [Story]()
        
        for currentObject in objects {
            let newStory = Story()
            
            newStory.id = Int64(currentObject["id"] as! Int)
            if let _ = currentObject["description"] as? String {
                newStory.descriptionStory = (currentObject["description"] as? String)!
            }
            else {
                newStory.descriptionStory = ""
            }
            newStory.title = (currentObject["title"] as? String)!
            newStory.resourceURI = (currentObject["resourceURI"] as? String)!
            newStory.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            newStory.type = (currentObject["type"] as? String)!
            
            if let _ = currentObject["thumbnail"] as? NSDictionary {
                let path = (currentObject["thumbnail"] as! [String : String])["path"]! as String
                let extensionImage = (currentObject["thumbnail"] as! [String : String])["extension"]! as String
                newStory.thumbnail = "\(path).\(extensionImage)"
                DownloadManager.downloadImage(newStory)
            }
            else {
                newStory.thumbnail = ""
            }
            stories.append(newStory)
        }
        
        return stories
    }
    
}
