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
class Event: ItemMarvel {
    
    static let imageName = "events"
    
	let descriptionEvent: String
	let end: Date
	let modified: Date
	let resourceURI: String
	let start: Date
	let title: String
	
    init(id: Int64,
         thumbnail: String?,
         mainText: String,
         descriptionText: String,
         descriptionEvent: String,
         end: Date,
         modified: Date,
         resourceURI: String,
         start: Date,
         title: String ) {
        self.descriptionEvent = descriptionEvent
        self.end = end
        self.modified = modified
        self.resourceURI = resourceURI
        self.start = start
        self.title = title
        super.init(id: id,
                   thumbnail: thumbnail,
                   mainText: mainText,
                   descriptionText: descriptionText)
    }
    
}
