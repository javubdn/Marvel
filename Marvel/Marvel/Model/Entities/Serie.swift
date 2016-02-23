//
//  Serie.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Serie {
	var id:Int64
	var descriptionSerie:String
	var startYear:Int64
	var endYear:Int64
	var modified:NSDate
	var rating:String
	var resourceURI:String
	var title:String
	
	init() {
		id = 0
		descriptionSerie = ""
		startYear = 0
		endYear = 0
		modified = NSDate()
		rating = ""
		resourceURI = ""
		title = ""
	}
    
    static func serieWithManagedObject(object:NSManagedObject)->Serie {
        let serie = Serie()
		serie.id = Int64((object.valueForKey("id") as! Int))
        serie.descriptionSerie = (object.valueForKey("descriptionSerie") as? String)!
        serie.startYear = Int64((object.valueForKey("startYear") as! Int))
        serie.endYear = Int64((object.valueForKey("endYear") as! Int))
        serie.modified = (object.valueForKey("modified") as? NSDate)!
        serie.rating = (object.valueForKey("rating") as? String)!
        serie.resourceURI = (object.valueForKey("resourceURI") as? String)!
        serie.title = (object.valueForKey("title") as? String)!
        
        return serie
    }
    
    static func getSeriesWithObjects(objects:[NSManagedObject])->[Serie] {
        var series:[Serie] = []
        
        for(var i=0; i < objects.count; i++) {
            let newSerie = Serie.serieWithManagedObject((objects[i] as NSManagedObject))
            series.insert(newSerie, atIndex: i)
        }
        
        return series
    }
	
	static func managedObjectWithSerie(serie:Serie)->NSManagedObject {
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		//We get the entity for type Character
		let entity =  NSEntityDescription.entityForName("Serie", inManagedObjectContext:managedContext)
	 
		let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
	 
		object.setValue(NSNumber(longLong: serie.id), forKey: "id")
		object.setValue(serie.descriptionSerie, forKey: "descriptionSerie")
		object.setValue(NSNumber(longLong: serie.startYear), forKey: "startYear")
		object.setValue(NSNumber(longLong: serie.endYear), forKey: "endYear")
		object.setValue(serie.modified, forKey: "modified")
		object.setValue(serie.rating, forKey: "rating")
		object.setValue(serie.resourceURI, forKey: "resourceURI")
		object.setValue(serie.title, forKey: "title")
		
		return object
		
	}
}