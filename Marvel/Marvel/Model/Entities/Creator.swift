//
//  Creator.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Creator {

	var id:Int64
	var firstName:String
	var fullName:String
	var lastName:String
	var middleName:String
	var modified:NSDate
	var resourceURI:String
	var suffix:String
	
	init() {
		id = 0
		firstName = ""
		fullName = ""
		lastName = ""
		middleName = ""
		modified = NSDate()
		resourceURI = ""
		suffix = ""
	}
    
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
        
        return creator
    }
    
    static func getCreatorsWithObjects(objects:[NSManagedObject])->[Creator] {
        var creators:[Creator] = []
        
        for(var i=0; i < objects.count; i++) {
            let newCreator = Creator.creatorWithManagedObject((objects[i] as NSManagedObject))
            creators.insert(newCreator, atIndex: i)
        }
        
        return creators
    }
	
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
		
		return object
		
	}
	
}
