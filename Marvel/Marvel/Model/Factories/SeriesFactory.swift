//
//  SeriesFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class to create the instances of Serie
class SeriesFactory {
    
    /**
     This method gets a Serie from a NSManagedObject
     
     - parameter object: Register we use to create the serie
     
     - returns: Serie with the data of the register
     */
    static func serieWithManagedObject(_ object:NSManagedObject)->Serie {
        let serie = Serie()
        serie.id = Int64((object.value(forKey: "id") as! Int))
        serie.descriptionSerie = (object.value(forKey: "descriptionSerie") as? String)!
        serie.startYear = Int64((object.value(forKey: "startYear") as! Int))
        serie.endYear = Int64((object.value(forKey: "endYear") as! Int))
        serie.modified = (object.value(forKey: "modified") as? Date)!
        serie.rating = (object.value(forKey: "rating") as? String)!
        serie.resourceURI = (object.value(forKey: "resourceURI") as? String)!
        serie.title = (object.value(forKey: "title") as? String)!
        serie.type = (object.value(forKey: "type") as? String)!
        serie.thumbnail = (object.value(forKey: "thumbnail") as? String)!
        
        return serie
    }
    
    /**
     This method gets an array of Series from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of series
     */
    static func getSeriesWithObjects(_ objects:[NSManagedObject])->[Serie] {
        var series = [Serie]()
        
        for object in objects {
            let newSerie = serieWithManagedObject(object as NSManagedObject)
            series.append(newSerie)
        }
        
        return series
    }
    
    /**
     This method gets an NSManagedObject from a Serie
     
     - parameter serie: Serie to get the register
     
     - returns: Register to store with the data of the serie
     */
    static func managedObjectWithSerie(_ serie:Serie)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Serie", in:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(NSNumber(value: serie.id as Int64), forKey: "id")
        object.setValue(serie.descriptionSerie, forKey: "descriptionSerie")
        object.setValue(NSNumber(value: serie.startYear as Int64), forKey: "startYear")
        object.setValue(NSNumber(value: serie.endYear as Int64), forKey: "endYear")
        object.setValue(serie.modified, forKey: "modified")
        object.setValue(serie.rating, forKey: "rating")
        object.setValue(serie.resourceURI, forKey: "resourceURI")
        object.setValue(serie.title, forKey: "title")
        object.setValue(serie.type, forKey: "type")
        object.setValue(serie.thumbnail, forKey: "thumbnail")
        
        return object
        
    }
    
    /**
     This method an array of Series from a dictionary (the one that comes from the Marvel's API)
     
     - parameter objects: list of items that we obtain from the call to the Marvel API
     
     - returns: array of series
     */
    static func getSeriesWithArrayDictionaries(_ objects:[[String: Any]])->[Serie] {
        var series = [Serie]()
        
        for currentObject in objects {
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
            
            let path = (currentObject["thumbnail"] as! [String : String])["path"]! as String
            let extensionImage = (currentObject["thumbnail"] as! [String : String])["extension"]! as String
            newSerie.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newSerie)
            
            series.append(newSerie)
        }
        
        return series
    }

}
