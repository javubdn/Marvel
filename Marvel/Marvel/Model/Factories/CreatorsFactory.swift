//
//  CreatorsFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import UIKit
import CoreData

/// Class to create the instances of Creator
class CreatorsFactory {
    
    /**
     This method gets a Creator from a NSManagedObject
     
     - parameter object: Register we use to create the creator
     
     - returns: Creator with the data of the register
     */
    static func creatorWithManagedObject(_ object: NSManagedObject) -> Creator {
        let creator = Creator(id: Int64((object.value(forKey: "id") as! Int)),
                              thumbnail: (object.value(forKey: "thumbnail") as? String)!,
                              mainText: (object.value(forKey: "fullName") as? String)!,
                              descriptionText: (object.value(forKey: "fullName") as? String)!,
                              firstName: (object.value(forKey: "firstName") as? String)!,
                              fullName: (object.value(forKey: "fullName") as? String)!,
                              lastName: (object.value(forKey: "lastName") as? String)!,
                              middleName: (object.value(forKey: "middleName") as? String)!,
                              modified: (object.value(forKey: "modified") as? Date)!,
                              resourceURI: (object.value(forKey: "resourceURI") as? String)!,
                              suffix: (object.value(forKey: "suffix") as? String)!)
        return creator
    }
    
    /**
     This method gets an array of Creator from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of creators
     */
    static func getCreatorsWithObjects(_ objects: [NSManagedObject]) -> [Creator] {
        var creators = [Creator]()
        
        for object in objects {
            let newCreator = creatorWithManagedObject(object)
            creators.append(newCreator)
        }
        
        return creators
    }
    
    /**
     This method gets an NSManagedObject from a Creator
     
     - parameter creator: Creator to get the register
     
     - returns: Register to store with the data of the creator
     */
    static func managedObjectWithCreator(_ creator: Creator) -> NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Creator", in: managedContext)
        
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
    static func getCreatorsWithArrayDictionaries(_ objects: [[String: Any]]) -> [Creator] {
        var creators = [Creator]()
        
        for currentObject in objects {
            var thumbnail: String?
            if let thumbnailItem = currentObject["thumbnail"] as? [String: String],
                let path = thumbnailItem["path"],
                let extensionImage = thumbnailItem["extension"] {
                thumbnail = "\(path).\(extensionImage)"
            }
            var modifiedDate = Date()
            if(currentObject["modified"] != nil) {
                modifiedDate = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            }
            let newCreator = Creator(id: Int64(currentObject["id"] as! Int),
                                     thumbnail: thumbnail,
                                     mainText: (currentObject["fullName"] as? String)!,
                                     descriptionText: (currentObject["fullName"] as? String)!,
                                     firstName: (currentObject["firstName"] as? String)!,
                                     fullName: (currentObject["fullName"] as? String)!,
                                     lastName: (currentObject["lastName"] as? String)!,
                                     middleName: (currentObject["middleName"] as? String)!,
                                     modified: modifiedDate,
                                     resourceURI: (currentObject["resourceURI"] as? String)!,
                                     suffix: (currentObject["suffix"] as? String)!)
            DownloadManager.downloadImage(newCreator)
            
            creators.append(newCreator)
        }
        
        return creators
    }

}
