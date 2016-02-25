//
//  CreatorsFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreatorsFactory {
    
    /**
     This method gets a Creator from a NSManagedObject
     
     - parameter object: Register we use to create the creator
     
     - returns: Creator with the data of the register
     */
    static func creatorWithManagedObject(object:NSManagedObject)->Creator {
        let creator = Creator()
        creator.id = Int64((object.valueForKey("id") as! Int))
        creator.firstName = (object.valueForKey("firstName") as? String)!
        creator.fullName = (object.valueForKey("fullName") as? String)!
        creator.lastName = (object.valueForKey("lastName") as? String)!
        creator.middleName = (object.valueForKey("middleName") as? String)!
        creator.modified = (object.valueForKey("modified") as? NSDate)!
        creator.resourceURI = (object.valueForKey("resourceURI") as? String)!
        creator.suffix = (object.valueForKey("suffix") as? String)!
        creator.thumbnail = (object.valueForKey("thumbnail") as? String)!
        
        return creator
    }
    
    /**
     This method gets an array of Creator from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of creators
     */
    static func getCreatorsWithObjects(objects:[NSManagedObject])->[Creator] {
        var creators:[Creator] = []
        
        for(var i=0; i < objects.count; i++) {
            let newCreator = creatorWithManagedObject((objects[i] as NSManagedObject))
            creators.insert(newCreator, atIndex: i)
        }
        
        return creators
    }
    
    /**
     This method gets an NSManagedObject from a Creator
     
     - parameter creator: Creator to get the register
     
     - returns: Register to store with the data of the creator
     */
    static func managedObjectWithCreator(creator:Creator)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entityForName("Creator", inManagedObjectContext:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        object.setValue(NSNumber(longLong: creator.id), forKey: "id")
        object.setValue(creator.firstName, forKey: "firstName")
        object.setValue(creator.fullName, forKey: "fullName")
        object.setValue(creator.lastName, forKey: "lastName")
        object.setValue(creator.middleName, forKey: "middleName")
        object.setValue(creator.modified, forKey: "modified")
        object.setValue(creator.resourceURI, forKey: "resourceURI")
        object.setValue(creator.suffix, forKey: "suffix")
        object.setValue(creator.thumbnail, forKey: "thumbnail")
        
        return object
        
    }
    
    /**
     This method an array of Creators from a dictionary (the one that comes from the Marvel's API)
     
     - parameter objects: list of items that we obtain from the call to the Marvel API
     
     - returns: array of cretors
     */
    static func getCreatorsWithArrayDictionaries(objects:NSArray)->[Creator] {
        var creators:[Creator] = []
        
        for(var i=0; i < objects.count; i++) {
            let currentObject = objects[i]
            let newCreator = Creator()
            
            newCreator.id = Int64(currentObject["id"] as! Int)
            newCreator.firstName = (currentObject["firstName"] as? String)!
            newCreator.fullName = (currentObject["fullName"] as? String)!
            newCreator.lastName = (currentObject["lastName"] as? String)!
            newCreator.middleName = (currentObject["middleName"] as? String)!
            if(currentObject["modified"] != nil) {
                newCreator.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            }
            newCreator.resourceURI = (currentObject["resourceURI"] as? String)!
            newCreator.suffix = (currentObject["suffix"] as? String)!
            
            let path = (currentObject["thumbnail"]!!["path"] as? String)!
            let extensionImage = (currentObject["thumbnail"]!!["extension"] as? String)!
            newCreator.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newCreator, category: Constants.TypeData.Creators)
            
            creators.insert(newCreator, atIndex: i)
        }
        
        return creators
    }

}