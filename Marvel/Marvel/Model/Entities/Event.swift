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

/// Class that contain the data of a Event
class Event:ItemMarvel {
	var descriptionEvent:String
	var end:Date
	var modified:Date
	var resourceURI:String
	var start:Date
	var title:String
	
	override init() {
		descriptionEvent = ""
		start = Date()
		end = Date()
		modified = Date()
		resourceURI = ""
		title = ""
	}
    
}
