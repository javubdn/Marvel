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

/// Class that contain the data of a Comic
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
    
}