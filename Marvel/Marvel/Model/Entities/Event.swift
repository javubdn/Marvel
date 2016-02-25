//
//  Event.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Event:NSObject {
	var id:Int64
	var descriptionEvent:String
	var end:NSDate
	var modified:NSDate
	var resourceURI:String
	var start:NSDate
	var title:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	override init() {
		id = 0
		descriptionEvent = ""
		start = NSDate()
		end = NSDate()
		modified = NSDate()
		resourceURI = ""
		title = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
}
