//
//  Comic.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Comic:NSObject {
	var id:Int64
	var descriptionComic:String
	var diamondCode:String
	var digitalId:Int64
	var ean:String
	var format:String
	var isbn:String
	var issn:String
	var issueNumber:Int64
	var modified:NSDate
	var pageCount:Int64
	var resourceURI:String
	var title:String
	var upc:String
	var variantDescription:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	override init() {
		id = 0
		descriptionComic = ""
		diamondCode = ""
		digitalId = 0
		ean = ""
		format = ""
		isbn = ""
		issn = ""
		issueNumber = 0
		modified = NSDate()
		pageCount = 0
		resourceURI = ""
		title = ""
		upc = ""
		variantDescription = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
    /**
     *	This method gets a Comic from a NSManagedObject
     */
    static func comicWithManagedObject(object:NSManagedObject)->Comic {
        let comic = Comic()
        comic.id = Int64((object.valueForKey("id") as! Int))
        comic.descriptionComic = (object.valueForKey("descriptionComic") as? String)!
        comic.diamondCode = (object.valueForKey("diamondCode") as? String)!
        comic.digitalId = Int64((object.valueForKey("digitalId") as! Int))
        comic.ean = (object.valueForKey("ean") as? String)!
        comic.format = (object.valueForKey("format") as? String)!
        comic.isbn = (object.valueForKey("isbn") as? String)!
        comic.issn = (object.valueForKey("issn") as? String)!
        comic.issueNumber = Int64((object.valueForKey("issueNumber") as! Int))
        comic.modified = (object.valueForKey("modified") as? NSDate)!
        comic.pageCount = Int64((object.valueForKey("pageCount") as! Int))
        comic.resourceURI = (object.valueForKey("resourceURI") as? String)!
        comic.title = (object.valueForKey("title") as? String)!
        comic.upc = (object.valueForKey("upc") as? String)!
        comic.variantDescription = (object.valueForKey("variantDescription") as? String)!
        comic.thumbnail = (object.valueForKey("thumbnail") as? String)!
        
        return comic
    }
    
    /**
     *	This method gets an array of Comic from an array of NSManagedObject
     */
    static func getComicsWithObjects(objects:[NSManagedObject])->[Comic] {
        var comics:[Comic] = []
        
        for(var i=0; i < objects.count; i++) {
            let newComic = Comic.comicWithManagedObject((objects[i] as NSManagedObject))
            comics.insert(newComic, atIndex: i)
        }
        
        return comics
    }
	
    /**
     *	This method gets an NSManagedObject from a Comic
     */
	static func managedObjectWithComic(comic:Comic)->NSManagedObject {
		
		//We need the managedContext
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		//We get the entity for type Character
		let entity =  NSEntityDescription.entityForName("Comic", inManagedObjectContext:managedContext)
	 
		let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
	 
		object.setValue(NSNumber(longLong: comic.id), forKey: "id")
		object.setValue(comic.descriptionComic, forKey: "descriptionComic")
		object.setValue(comic.diamondCode, forKey: "diamondCode")
		object.setValue(NSNumber(longLong: comic.digitalId), forKey: "digitalId")
		object.setValue(comic.ean, forKey: "ean")
		object.setValue(comic.format, forKey: "format")
		object.setValue(comic.isbn, forKey: "isbn")
		object.setValue(comic.issn, forKey: "issn")
		object.setValue(NSNumber(longLong:comic.issueNumber), forKey: "issueNumber")
		object.setValue(comic.modified, forKey: "modified")
		object.setValue(NSNumber(longLong:comic.pageCount), forKey: "pageCount")
		object.setValue(comic.resourceURI, forKey: "resourceURI")
		object.setValue(comic.title, forKey: "title")
		object.setValue(comic.upc, forKey: "upc")
		object.setValue(comic.variantDescription, forKey: "variantDescription")
		object.setValue(comic.thumbnail, forKey: "thumbnail")
        
		return object
		
	}
    
    /**
     *	This method an array of Comics from a dictionary (the one that comes from the Marvel's API)
     */
    static func getComicsWithArrayDictionaries(objects:NSArray)->[Comic] {
        var comics:[Comic] = []
        
        for(var i=0; i < objects.count; i++) {
            let currentObject = objects[i]
            let newComic = Comic()
            
            newComic.id = Int64(currentObject["id"] as! Int)
            if let _ = currentObject["description"] as? String {
                newComic.descriptionComic = (currentObject["description"] as? String)!
            }
            else {
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
            
            let path = (currentObject["thumbnail"]!!["path"] as? String)!
            let extensionImage = (currentObject["thumbnail"]!!["extension"] as? String)!
            newComic.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newComic, category: Constants.TypeData.Comics)
            
            comics.insert(newComic, atIndex: i)
        }
        
        return comics
    }
	
}