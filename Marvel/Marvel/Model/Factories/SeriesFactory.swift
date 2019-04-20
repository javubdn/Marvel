//
//  SeriesFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import UIKit
import CoreData

/// Class to create the instances of Serie
class SeriesFactory {
    
    /**
     This method gets a Serie from a NSManagedObject
     
     - parameter object: Register we use to create the serie
     
     - returns: Serie with the data of the register
     */
    static func serieWithManagedObject(_ object: NSManagedObject) -> Serie {
        let serie = Serie(id: Int64((object.value(forKey: "id") as! Int)),
                          thumbnail: (object.value(forKey: "thumbnail") as? String)!,
                          mainText: (object.value(forKey: "title") as? String)!,
                          descriptionText: (object.value(forKey: "descriptionSerie") as? String)!,
                          descriptionSerie: (object.value(forKey: "descriptionSerie") as? String)!,
                          startYear: Int64((object.value(forKey: "startYear") as! Int)),
                          endYear: Int64((object.value(forKey: "endYear") as! Int)),
                          modified: (object.value(forKey: "modified") as? Date)!,
                          rating: (object.value(forKey: "rating") as? String)!,
                          resourceURI: (object.value(forKey: "resourceURI") as? String)!,
                          title: (object.value(forKey: "title") as? String)!,
                          type: (object.value(forKey: "type") as? String)!)

        return serie
    }
    
    /**
     This method gets an array of Series from an array of NSManagedObject
     
     - parameter objects: array of registers to get the creators
     
     - returns: list of series
     */
    static func getSeriesWithObjects(_ objects:[NSManagedObject]) -> [Serie] {
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
            let path = (currentObject["thumbnail"] as! [String : String])["path"]! as String
            let extensionImage = (currentObject["thumbnail"] as! [String : String])["extension"]! as String
            let newSerie = Serie(id: Int64(currentObject["id"] as! Int),
                                 thumbnail: "\(path).\(extensionImage)",
                mainText: (currentObject["title"] as? String)!,
                descriptionText: (currentObject["description"] as? String) ?? "",
                descriptionSerie: (currentObject["description"] as? String) ?? "",
                startYear: Int64(currentObject["startYear"] as! Int),
                endYear: Int64(currentObject["endYear"] as! Int),
                modified: Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS"),
                rating: (currentObject["rating"] as? String)!,
                resourceURI: (currentObject["resourceURI"] as? String)!,
                title: (currentObject["title"] as? String)!,
                type: (currentObject["type"] as? String)!)
            
            DownloadManager.downloadImage(newSerie)
            series.append(newSerie)
        }
        
        return series
    }

}
