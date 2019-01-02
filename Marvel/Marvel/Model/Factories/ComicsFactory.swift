//
//  ComicsFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class to create the instances of Comic
class ComicsFactory {
    
    /**
     This method gets a Comic from a NSManagedObject
     
     - parameter object: Register we use to create the comic
     
     - returns: Comic with the data of the register
     */
    static func comicWithManagedObject(_ object:NSManagedObject)->Comic {
        let comic = Comic()
        comic.id = Int64((object.value(forKey: "id") as! Int))
        comic.descriptionComic = (object.value(forKey: "descriptionComic") as? String)!
        comic.diamondCode = (object.value(forKey: "diamondCode") as? String)!
        comic.digitalId = Int64((object.value(forKey: "digitalId") as! Int))
        comic.ean = (object.value(forKey: "ean") as? String)!
        comic.format = (object.value(forKey: "format") as? String)!
        comic.isbn = (object.value(forKey: "isbn") as? String)!
        comic.issn = (object.value(forKey: "issn") as? String)!
        comic.issueNumber = Int64((object.value(forKey: "issueNumber") as! Int))
        comic.modified = (object.value(forKey: "modified") as? Date)!
        comic.pageCount = Int64((object.value(forKey: "pageCount") as! Int))
        comic.resourceURI = (object.value(forKey: "resourceURI") as? String)!
        comic.title = (object.value(forKey: "title") as? String)!
        comic.upc = (object.value(forKey: "upc") as? String)!
        comic.variantDescription = (object.value(forKey: "variantDescription") as? String)!
        comic.thumbnail = (object.value(forKey: "thumbnail") as? String)!
        
        return comic
    }
    
    /**
     This method gets an array of Comics from an array of NSManagedObject
     
     - parameter objects: array of registers to get the comics
     
     - returns: list of comics
     */
    static func getComicsWithObjects(_ objects:[NSManagedObject])->[Comic] {
        var comics = [Comic]()
        for object in objects {
            let newComic = comicWithManagedObject((object as NSManagedObject))
            comics.append(newComic)
        }
        return comics
    }
    
    /**
     This method gets an NSManagedObject from a Comic
     
     - parameter comic: Comic to get the register
     
     - returns: Register to store with the data of the comic
     */
    static func managedObjectWithComic(_ comic:Comic)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Comic", in:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(NSNumber(value: comic.id as Int64), forKey: "id")
        object.setValue(comic.descriptionComic, forKey: "descriptionComic")
        object.setValue(comic.diamondCode, forKey: "diamondCode")
        object.setValue(NSNumber(value: comic.digitalId as Int64), forKey: "digitalId")
        object.setValue(comic.ean, forKey: "ean")
        object.setValue(comic.format, forKey: "format")
        object.setValue(comic.isbn, forKey: "isbn")
        object.setValue(comic.issn, forKey: "issn")
        object.setValue(NSNumber(value: comic.issueNumber as Int64), forKey: "issueNumber")
        object.setValue(comic.modified, forKey: "modified")
        object.setValue(NSNumber(value: comic.pageCount as Int64), forKey: "pageCount")
        object.setValue(comic.resourceURI, forKey: "resourceURI")
        object.setValue(comic.title, forKey: "title")
        object.setValue(comic.upc, forKey: "upc")
        object.setValue(comic.variantDescription, forKey: "variantDescription")
        object.setValue(comic.thumbnail, forKey: "thumbnail")
        
        return object
        
    }
    
    /**
     This method an array of Comics from a dictionary (the one that comes from the Marvel's API)
     
     - parameter objects: list of items that we obtain from the call to the Marvel API
     
     - returns: array of comics
     */
    static func getComicsWithArrayDictionaries(_ objects:[[String: Any]])->[Comic] {
        var comics:[Comic] = []
        for currentObject in objects {
            let newComic = Comic()
            newComic.id = Int64(currentObject["id"] as! Int)
            if let _ = currentObject["description"] as? String {
                newComic.descriptionComic = (currentObject["description"] as? String)!
            } else {
                newComic.descriptionComic = ""
            }
            if let _ = currentObject["diamondCode"] as? String {
                newComic.diamondCode = (currentObject["diamondCode"] as? String)!
            }
            else {
                newComic.diamondCode = ""
            }
            
            newComic.digitalId = Int64(currentObject["digitalId"] as! Int)
            newComic.ean = (currentObject["ean"] as? String)!
            newComic.format = (currentObject["format"] as? String)!
            newComic.isbn = (currentObject["isbn"] as? String)!
            newComic.issn = (currentObject["issn"] as? String)!
            newComic.issueNumber = Int64(currentObject["issueNumber"] as! Int)
            newComic.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            newComic.pageCount = Int64(currentObject["pageCount"] as! Int)
            newComic.resourceURI = (currentObject["resourceURI"] as? String)!
            newComic.title = (currentObject["title"] as? String)!
            newComic.upc = (currentObject["upc"] as? String)!
            newComic.variantDescription = (currentObject["variantDescription"] as? String)!
            
            let path = (currentObject["thumbnail"] as! [String : String])["path"]! as String
            let extensionImage = (currentObject["thumbnail"] as! [String : String])["extension"]! as String
            newComic.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newComic)
            
            comics.append(newComic)
        }
        
        return comics
    }
    
}
