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
class Serie:NSObject {
	var id:Int64
	var descriptionSerie:String
	var startYear:Int64
	var endYear:Int64
	var modified:NSDate
	var rating:String
	var resourceURI:String
	var title:String
    var type:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	override init() {
		id = 0
		descriptionSerie = ""
		startYear = 0
		endYear = 0
		modified = NSDate()
		rating = ""
		resourceURI = ""
		title = ""
        type = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
}