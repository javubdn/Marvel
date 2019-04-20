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
    static func storyWithManagedObject(_ object:NSManagedObject) -> Story {
        var thumbnail: String?
        if let thumbnailStored = object.value(forKey: "thumbnail") as? String {
            thumbnail = thumbnailStored
        }
        
        let story = Story(id: Int64((object.value(forKey: "id") as! Int)),
                          thumbnail: thumbnail,
                          mainText: (object.value(forKey: "title") as? String)!,
                          descriptionText: (object.value(forKey: "descriptionStory") as? String)!,
                          descriptionStory: (object.value(forKey: "descriptionStory") as? String)!,
                          modified: (object.value(forKey: "modified") as? Date)!,
                          resourceURI: (object.value(forKey: "resourceURI") as? String)!,
                          title: (object.value(forKey: "title") as? String)!,
                          type: (object.value(forKey: "type") as? String)!)
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
            var thumbnail: String?
            if let thumbnailItem = currentObject["thumbnail"] as? [String : String],
                let path = thumbnailItem["path"],
                let extensionImage = thumbnailItem["extension"] {
                thumbnail = "\(path).\(extensionImage)"
            }
            
            let newStory = Story(id: Int64(currentObject["id"] as! Int),
                                 thumbnail: thumbnail,
                mainText: (currentObject["title"] as? String)!,
                descriptionText: currentObject["description"] as? String ?? "",
                descriptionStory: currentObject["description"] as? String ?? "",
                modified: Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS"),
                resourceURI: (currentObject["resourceURI"] as? String)!,
                title: (currentObject["title"] as? String)!,
                type: (currentObject["type"] as? String)!)
            DownloadManager.downloadImage(newStory)
            stories.append(newStory)
        }
        
        return stories
    }
    
}
