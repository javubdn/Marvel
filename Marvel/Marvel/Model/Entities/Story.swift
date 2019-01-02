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

/// Class that contain the data of a Story
class Story:ItemMarvel {
	var descriptionStory:String
	var modified:Date
	var resourceURI:String
	var title:String
	var type:String
	
	override init() {
		descriptionStory = ""
		modified = Date()
		resourceURI = ""
		title = ""
		type = ""
	}
    
}
