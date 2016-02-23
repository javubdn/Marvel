//
//  Event.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Event {
	var id:Int64
	var descriptionEvent:String
	var end:NSDate
	var modified:NSDate
	var resourceURI:String
	var start:NSDate
	var title:String
	
	init() {
		id = 0
		descriptionEvent = ""
		start = NSDate()
		end = NSDate()
		modified = NSDate()
		resourceURI = ""
		title = ""
	}
    
    static func eventWithManagedObject(object:NSManagedObject)->Event {
        let event = Event()
		event.id = Int64((object.valueForKey("id") as! Int))
        event.descriptionEvent = (object.valueForKey("descriptionEvent") as? String)!
        event.start = (object.valueForKey("start") as? NSDate)!
        event.end = (object.valueForKey("end") as? NSDate)!
        event.modified = (object.valueForKey("modified") as? NSDate)!
        event.resourceURI = (object.valueForKey("resourceURI") as? String)!
        event.title = (object.valueForKey("title") as? String)!
        
        return event
    }
    
    static func getEventsWithObjects(objects:[NSManagedObject])->[Event] {
        var events:[Event] = []
        
        for(var i=0; i < objects.count; i++) {
            let newEvent = Event.eventWithManagedObject((objects[i] as NSManagedObject))
            events.insert(newEvent, atIndex: i)
        }
        
        return events
    }
	
	static func managedObjectWithEvent(event:Event)->NSManagedObject {
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		//We get the entity for type Character
		let entity =  NSEntityDescription.entityForName("Event", inManagedObjectContext:managedContext)
	 
		let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
	 
		object.setValue(NSNumber(longLong: event.id), forKey: "id")
		object.setValue(event.descriptionEvent, forKey: "descriptionEvent")
		object.setValue(event.start, forKey: "start")
		object.setValue(event.end, forKey: "end")
		object.setValue(event.modified, forKey: "modified")
		object.setValue(event.resourceURI, forKey: "resourceURI")
		object.setValue(event.title, forKey: "title")
		
		return object
		
	}
}
