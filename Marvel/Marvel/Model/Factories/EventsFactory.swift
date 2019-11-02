//
//  EventsFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import UIKit
import CoreData

/// Class to create the instances of Event
class EventsFactory {
    
    /**
     This method gets a Event from a NSManagedObject
     
     - parameter object: Register we use to create the event
     
     - returns: Event with the data of the register
     */
    static func eventWithManagedObject(_ object:NSManagedObject)->Event {
        let event = Event(id: Int64((object.value(forKey: "id") as! Int)),
                          thumbnail: (object.value(forKey: "thumbnail") as? String)!,
                          mainText: (object.value(forKey: "title") as? String)!,
                          descriptionText: (object.value(forKey: "descriptionEvent") as? String)!,
                          descriptionEvent: (object.value(forKey: "descriptionEvent") as? String)!,
                          end: (object.value(forKey: "end") as? Date)!,
                          modified: (object.value(forKey: "modified") as? Date)!,
                          resourceURI: (object.value(forKey: "resourceURI") as? String)!,
                          start: (object.value(forKey: "start") as? Date)!,
                          title: (object.value(forKey: "title") as? String)!)        
        return event
    }
    
    /**
     This method gets an array of Events from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of events
     */
    static func getEventsWithObjects(_ objects:[NSManagedObject])->[Event] {
        var events:[Event] = []
        
        for object in objects {
            let newEvent = eventWithManagedObject(object as NSManagedObject)
            events.append(newEvent)
        }
        
        return events
    }
    
    /**
     This method gets an NSManagedObject from a Event
     
     - parameter event: Event to get the register
     
     - returns: Register to store with the data of the event
     */
    static func managedObjectWithEvent(_ event:Event)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Event", in:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(NSNumber(value: event.id as Int64), forKey: "id")
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
    static func getEventsWithArrayDictionaries(_ objects:[[String: Any]])->[Event] {
        var events = [Event]()
        
        for currentObject in objects {
            var thumbnail: String?
            if let thumbnailItem = currentObject["thumbnail"] as? [String: String],
                let path = thumbnailItem["path"],
                let extensionImage = thumbnailItem["extension"] {
                thumbnail = "\(path).\(extensionImage)"
            }
            var newEventStart = Date()
            var newEventEnd = Date()
            if let _ = currentObject["start"] as? String {
                newEventStart = Constants.convertDateFormater((currentObject["start"] as? String)!, format: "yyyy-MM-dd HH:mm:ss")
            }
            if let _ = currentObject["end"] as? String {
                newEventEnd = Constants.convertDateFormater((currentObject["end"] as? String)!, format: "yyyy-MM-dd HH:mm:ss")
            }
            let newEvent = Event(id: Int64(currentObject["id"] as! Int),
                                 thumbnail: thumbnail,
                                 mainText: (currentObject["title"] as? String)!,
                                 descriptionText: currentObject["description"] as? String ?? "",
                                 descriptionEvent: currentObject["description"] as? String ?? "",
                                 end: newEventEnd,
                                 modified: Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS"),
                                 resourceURI: (currentObject["resourceURI"] as? String)!,
                                 start: newEventStart,
                                 title: (currentObject["title"] as? String)!)
            DownloadManager.downloadImage(newEvent)
            events.append(newEvent)
        }
        
        return events
    }

}
