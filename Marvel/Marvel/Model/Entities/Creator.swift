//
//  Creator.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that contain the data of a Creator
class Creator:ItemMarvel {

    static let imageName = "creators"
    
	let firstName: String
	let fullName: String
	let lastName: String?
	let middleName: String
	let modified: Date
	let resourceURI: String
	let suffix: String
	
    init(id: Int64,
         thumbnail: String?,
         mainText: String,
         descriptionText: String,
         firstName: String,
         fullName: String,
         lastName: String?,
         middleName: String,
         modified: Date,
         resourceURI: String,
         suffix: String) {
        self.firstName = firstName
        self.fullName = fullName
        self.lastName = lastName
        self.middleName = middleName
        self.modified = modified
        self.resourceURI = resourceURI
        self.suffix = suffix
        super.init(id: id,
                   thumbnail: thumbnail,
                   mainText: mainText,
                   descriptionText: descriptionText)
    }
	
}
