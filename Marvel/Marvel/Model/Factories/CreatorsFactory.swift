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

/// Class to create the instances of Creator
class CreatorsFactory {
    
    /**
     This method gets a Creator from a NSManagedObject
     
     - parameter object: Register we use to create the creator
     
     - returns: Creator with the data of the register
     */
    static func creatorWithManagedObject(_ object:NSManagedObject)->Creator {
        let creator = Creator()
        creator.id = Int64((object.value(forKey: "id") as! Int))
        creator.firstName = (object.value(forKey: "firstName") as? String)!
        creator.fullName = (object.value(forKey: "fullName") as? String)!
        creator.lastName = (object.value(forKey: "lastName") as? String)!
        creator.middleName = (object.value(forKey: "middleName") as? String)!
        creator.modified = (object.value(forKey: "modified") as? Date)!
        creator.resourceURI = (object.value(forKey: "resourceURI") as? String)!
        creator.suffix = (object.value(forKey: "suffix") as? String)!
        creator.thumbnail = (object.value(forKey: "thumbnail") as? String)!
        
        return creator
    }
    
    /**
     This method gets an array of Creator from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of creators
     */
    static func getCreatorsWithObjects(_ objects:[NSManagedObject])->[Creator] {
        var creators = [Creator]()
        
        for object in objects {
            let newCreator = creatorWithManagedObject(object as NSManagedObject)
            creators.append(newCreator)
        }
        
        return creators
    }
    
    /**
     This method gets an NSManagedObject from a Creator
     
     - parameter creator: Creator to get the register
     
     - returns: Register to store with the data of the creator
     */
    static func managedObjectWithCreator(_ creator:Creator)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Creator", in:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(NSNumber(value: creator.id as Int64), forKey: "id")
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
    static func getCreatorsWithArrayDictionaries(_ objects:[[String: Any]])->[Creator] {
        var creators = [Creator]()
        
        for currentObject in objects {
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
            
            let path = (currentObject["thumbnail"] as! [String : String])["path"]! as String
            let extensionImage = (currentObject["thumbnail"] as! [String : String])["extension"]! as String
            newCreator.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newCreator)
            
            creators.append(newCreator)
        }
        
        return creators
    }

}
