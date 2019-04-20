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
    
    static let imageName = "comics"
    
	let descriptionComic: String
	let diamondCode: String
	let digitalId: Int64
	let ean: String
	let format: String
	let isbn: String
	let issn: String
	let issueNumber: Int64
	let modified: Date
	let pageCount: Int64
	let resourceURI: String
	let title: String
	let upc: String
	let variantDescription: String
    
    init(id: Int64,
         thumbnail: String?,
         mainText: String,
         descriptionText: String,
         descriptionComic: String,
         diamondCode: String,
         digitalId: Int64,
         ean: String,
         format: String,
         isbn: String,
         issn: String,
         issueNumber: Int64,
         modified: Date,
         pageCount: Int64,
         resourceURI: String,
         title: String,
         upc: String,
         variantDescription: String) {
        self.descriptionComic = descriptionComic
        self.diamondCode = diamondCode
        self.digitalId = digitalId
        self.ean = ean
        self.format = format
        self.isbn = isbn
        self.issn = issn
        self.issueNumber = issueNumber
        self.modified = modified
        self.pageCount = pageCount
        self.resourceURI = resourceURI
        self.title = title
        self.upc = upc
        self.variantDescription = variantDescription
        super.init(id: id,
                   thumbnail: thumbnail,
                   mainText: mainText,
                   descriptionText: descriptionText)
    }
    
}
