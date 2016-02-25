//
//  EventsFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class to create the instances of Event
class EventsFactory {
    
    /**
     This method gets a Event from a NSManagedObject
     
     - parameter object: Register we use to create the event
     
     - returns: Event with the data of the register
     */
    static func eventWithManagedObject(object:NSManagedObject)->Event {
        let event = Event()
        event.id = Int64((object.valueForKey("id") as! Int))
        event.descriptionEvent = (object.valueForKey("descriptionEvent") as? String)!
        event.start = (object.valueForKey("start") as? NSDate)!
        event.end = (object.valueForKey("end") as? NSDate)!
        event.modified = (object.valueForKey("modified") as? NSDate)!
        event.resourceURI = (object.valueForKey("resourceURI") as? String)!
        event.title = (object.valueForKey("title") as? String)!
        event.thumbnail = (object.valueForKey("thumbnail") as? String)!
        
        return event
    }
    
    /**
     This method gets an array of Events from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of events
     */
    static func getEventsWithObjects(objects:[NSManagedObject])->[Event] {
        var events:[Event] = []
        
        for(var i=0; i < objects.count; i++) {
            let newEvent = eventWithManagedObject((objects[i] as NSManagedObject))
            events.insert(newEvent, atIndex: i)
        }
        
        return events
    }
    
    /**
     This method gets an NSManagedObject from a Event
     
     - parameter event: Event to get the register
     
     - returns: Register to store with the data of the event
     */
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
        object.setValue(event.thumbnail, forKey: "thumbnail")
        
        return object
        
    }
    
    /**
     This method an array of Events from a dictionary (the one that comes from the Marvel's API)
     
     - parameter objects: list of items that we obtain from the call to the Marvel API
     
     - returns: array of events
     */
    static func getEventsWithArrayDictionaries(objects:NSArray)->[Event] {
        var events:[Event] = []
        
        for(var i=0; i < objects.count; i++) {
            let currentObject = objects[i]
            let newEvent = Event()
            
            newEvent.id = Int64(currentObject["id"] as! Int)
            if let _ = currentObject["description"] as? String {
                newEvent.descriptionEvent = (currentObject["description"] as? String)!
            }
            else {
                newEvent.descriptionEvent = ""
            }
            newEvent.resourceURI = (currentObject["resourceURI"] as? String)!
            newEvent.title = (currentObject["title"] as? String)!
            newEvent.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            if let _ = currentObject["start"] as? String {
                newEvent.start = Constants.convertDateFormater((currentObject["start"] as? String)!, format: "yyyy-MM-dd HH:mm:ss")
            }
            else {
                newEvent.start = NSDate()
            }
            if let _ = currentObject["end"] as? String {
                newEvent.end = Constants.convertDateFormater((currentObject["end"] as? String)!, format: "yyyy-MM-dd HH:mm:ss")
            }
            else {
                newEvent.end = NSDate()
            }
            
            let path = (currentObject["thumbnail"]!!["path"] as? String)!
            let extensionImage = (currentObject["thumbnail"]!!["extension"] as? String)!
            newEvent.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newEvent, category: Constants.TypeData.Events)
            
            events.insert(newEvent, atIndex: i)
        }
        
        return events
    }

}