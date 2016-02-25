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

class Serie:NSObject {
	var id:Int64
	var descriptionSerie:String
	var startYear:Int64
	var endYear:Int64
	var modified:NSDate
	var rating:String
	var resourceURI:String
	var title:String
    var type:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	override init() {
		id = 0
		descriptionSerie = ""
		startYear = 0
		endYear = 0
		modified = NSDate()
		rating = ""
		resourceURI = ""
		title = ""
        type = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
    /**
     *	This method gets a Serie from a NSManagedObject
     */
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
        serie.type = (object.valueForKey("type") as? String)!
        serie.thumbnail = (object.valueForKey("thumbnail") as? String)!
        
        return serie
    }
    
    /**
     *	This method gets an array of Series from an array of NSManagedObject
     */
    static func getSeriesWithObjects(objects:[NSManagedObject])->[Serie] {
        var series:[Serie] = []
        
        for(var i=0; i < objects.count; i++) {
            let newSerie = Serie.serieWithManagedObject((objects[i] as NSManagedObject))
            series.insert(newSerie, atIndex: i)
        }
        
        return series
    }
	
    /**
     *	This method gets an NSManagedObject from a Serie
     */
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
        object.setValue(serie.type, forKey: "type")
        object.setValue(serie.thumbnail, forKey: "thumbnail")
		
		return object
		
	}
    
    /**
     *	This method an array of Series from a dictionary (the one that comes from the Marvel's API)
     */
    static func getSeriesWithArrayDictionaries(objects:NSArray)->[Serie] {
        var series:[Serie] = []
        
        for(var i=0; i < objects.count; i++) {
            let currentObject = objects[i]
            let newSerie = Serie()
            
            newSerie.id = Int64(currentObject["id"] as! Int)

            if let _ = currentObject["description"] as? String {
                newSerie.descriptionSerie = (currentObject["description"] as? String)!
            }
            else {
                newSerie.descriptionSerie = ""
            }
            newSerie.title = (currentObject["title"] as? String)!
            newSerie.resourceURI = (currentObject["resourceURI"] as? String)!
            newSerie.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            newSerie.rating = (currentObject["rating"] as? String)!
            newSerie.type = (currentObject["type"] as? String)!
            newSerie.startYear = Int64(currentObject["startYear"] as! Int)
            newSerie.endYear = Int64(currentObject["endYear"] as! Int)
            
            let path = (currentObject["thumbnail"]!!["path"] as? String)!
            let extensionImage = (currentObject["thumbnail"]!!["extension"] as? String)!
            newSerie.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newSerie, category: Constants.TypeData.Series)
            
            series.insert(newSerie, atIndex: i)
        }
        
        return series
    }
}