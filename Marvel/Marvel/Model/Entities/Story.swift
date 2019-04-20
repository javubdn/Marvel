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
class Story: ItemMarvel {
    
    static let imageName = "stories"
    
	let descriptionStory: String
	let modified: Date
	let resourceURI: String
	let title: String
	let type: String
	
    init(id: Int64,
         thumbnail: String?,
         mainText: String,
         descriptionText: String,
         descriptionStory: String,
         modified: Date,
         resourceURI: String,
         title: String,
         type: String) {
        self.descriptionStory = descriptionStory
        self.modified = modified
        self.resourceURI = resourceURI
        self.title = title
        self.type = type
        super.init(id: id,
                   thumbnail: thumbnail,
                   mainText: mainText,
                   descriptionText: descriptionText)
    }
    
}
