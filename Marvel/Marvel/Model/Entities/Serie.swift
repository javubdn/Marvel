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

/// Class that contain the data of a Serie
class Serie: ItemMarvel {
    
    static let imageName = "series"
    
	let descriptionSerie: String
	let startYear: Int64
	let endYear: Int64
	let modified: Date
	let rating: String
	let resourceURI: String
	let title: String
    let type: String
	
    init(id: Int64,
         thumbnail: String?,
         mainText: String,
         descriptionText: String,
         descriptionSerie: String,
         startYear: Int64,
         endYear: Int64,
         modified: Date,
         rating: String,
         resourceURI: String,
         title: String,
         type: String) {
        self.descriptionSerie = descriptionSerie
        self.startYear = startYear
        self.endYear = endYear
        self.modified = modified
        self.rating = rating
        self.resourceURI = resourceURI
        self.title = title
        self.type = type
        super.init(id: id,
                   thumbnail: thumbnail,
                   mainText: mainText,
                   descriptionText: descriptionText)
    }
    
}
