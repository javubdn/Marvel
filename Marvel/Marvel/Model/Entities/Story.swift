//
//  Story.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Story:NSObject {
	var id:Int64
	var descriptionStory:String
	var modified:NSDate
	var resourceURI:String
	var title:String
	var type:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	override init() {
		id = 0
		descriptionStory = ""
		modified = NSDate()
		resourceURI = ""
		title = ""
		type = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
}