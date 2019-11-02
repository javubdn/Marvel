//
//  ComicsFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import UIKit
import CoreData

/// Class to create the instances of Comic
class ComicsFactory {
    
    /**
     This method gets a Comic from a NSManagedObject
     - parameter object: Register we use to create the comic
     - returns: Comic with the data of the register
     */
    static func comicWithManagedObject(_ object: NSManagedObject) -> Comic {
        let comic = Comic(id: Int64((object.value(forKey: "id") as! Int)),
                          thumbnail: (object.value(forKey: "thumbnail") as? String)!,
                          mainText: (object.value(forKey: "title") as? String)!,
                          descriptionText: (object.value(forKey: "descriptionComic") as? String)!,
                          descriptionComic: (object.value(forKey: "descriptionComic") as? String)!,
                          diamondCode: (object.value(forKey: "diamondCode") as? String)!,
                          digitalId: Int64((object.value(forKey: "digitalId") as! Int)),
                          ean: (object.value(forKey: "ean") as? String)!,
                          format: (object.value(forKey: "format") as? String)!,
                          isbn: (object.value(forKey: "isbn") as? String)!,
                          issn: (object.value(forKey: "issn") as? String)!,
                          issueNumber: Int64((object.value(forKey: "issueNumber") as! Int)),
                          modified: (object.value(forKey: "modified") as? Date)!,
                          pageCount: Int64((object.value(forKey: "pageCount") as! Int)),
                          resourceURI: (object.value(forKey: "resourceURI") as? String)!,
                          title: (object.value(forKey: "title") as? String)!,
                          upc: (object.value(forKey: "upc") as? String)!,
                          variantDescription: (object.value(forKey: "variantDescription") as? String)!)
        return comic
    }
    
    /**
     This method gets an array of Comics from an array of NSManagedObject
     - parameter objects: array of registers to get the comics
     - returns: list of comics
     */
    static func getComicsWithObjects(_ objects: [NSManagedObject]) -> [Comic] {
        var comics = [Comic]()
        for object in objects {
            let newComic = comicWithManagedObject(object)
            comics.append(newComic)
        }
        return comics
    }
    
    /**
     This method gets an NSManagedObject from a Comic
     - parameter comic: Comic to get the register
     - returns: Register to store with the data of the comic
     */
    static func managedObjectWithComic(_ comic: Comic) -> NSManagedObject {
        
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
    static func getComicsWithArrayDictionaries(_ objects: [[String: Any]]) -> [Comic] {
        var comics: [Comic] = []
        for currentObject in objects {
            var thumbnail: String?
            if let thumbnailItem = currentObject["thumbnail"] as? [String : String],
                let path = thumbnailItem["path"],
                let extensionImage = thumbnailItem["extension"] {
                thumbnail = "\(path).\(extensionImage)"
            }
            let newComic = Comic(id: Int64(currentObject["id"] as! Int),
                                 thumbnail: thumbnail,
                                 mainText: (currentObject["title"] as? String)!,
                                 descriptionText: currentObject["description"] as? String ?? "",
                                 descriptionComic: currentObject["description"] as? String ?? "",
                                 diamondCode: currentObject["diamondCode"] as? String ?? "",
                                 digitalId: Int64(currentObject["digitalId"] as! Int),
                                 ean: (currentObject["ean"] as? String)!,
                                 format: (currentObject["format"] as? String)!,
                                 isbn: (currentObject["isbn"] as? String)!,
                                 issn: (currentObject["issn"] as? String)!,
                                 issueNumber: Int64(currentObject["issueNumber"] as! Int),
                                 modified: Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS"),
                                 pageCount: Int64(currentObject["pageCount"] as! Int),
                                 resourceURI: (currentObject["resourceURI"] as? String)!,
                                 title: (currentObject["title"] as? String)!,
                                 upc: (currentObject["upc"] as? String)!,
                                 variantDescription: (currentObject["variantDescription"] as? String)!)
            
            DownloadManager.downloadImage(newComic)
            
            comics.append(newComic)
        }
        
        return comics
    }
    
}
