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
class Comic:ItemMarvel {
	var descriptionComic:String
	var diamondCode:String
	var digitalId:Int64
	var ean:String
	var format:String
	var isbn:String
	var issn:String
	var issueNumber:Int64
	var modified:Date
	var pageCount:Int64
	var resourceURI:String
	var title:String
	var upc:String
	var variantDescription:String
	
	override init() {
		descriptionComic = ""
		diamondCode = ""
		digitalId = 0
		ean = ""
		format = ""
		isbn = ""
		issn = ""
		issueNumber = 0
		modified = Date()
		pageCount = 0
		resourceURI = ""
		title = ""
		upc = ""
		variantDescription = ""
	}
    
}
