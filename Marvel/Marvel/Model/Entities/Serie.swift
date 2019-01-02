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
class Serie:ItemMarvel {
	var descriptionSerie:String
	var startYear:Int64
	var endYear:Int64
	var modified:Date
	var rating:String
	var resourceURI:String
	var title:String
    var type:String
	
	override init() {
		descriptionSerie = ""
		startYear = 0
		endYear = 0
		modified = Date()
		rating = ""
		resourceURI = ""
		title = ""
        type = ""
	}
    
}
