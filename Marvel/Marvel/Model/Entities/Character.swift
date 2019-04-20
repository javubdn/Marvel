//
//  Character.swift
//  Marvel
//
//  Created by Javi on 22/02/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that contain the data of a Character
class Character: ItemMarvel {
    
    static let imageName = "characters"
	
    let name: String
	let descriptionCharacter: String
	let modified: Date
	let resourceURI: String
    
    init(id: Int64,
         thumbnail: String?,
         mainText: String,
         descriptionText: String,
         name: String,
         descriptionCharacter: String,
         modified: Date,
         resourceURI: String) {
        self.name = name
        self.descriptionCharacter = descriptionCharacter
        self.modified = modified
        self.resourceURI = resourceURI
        super.init(id: id,
                   thumbnail: thumbnail,
                   mainText: mainText,
                   descriptionText: descriptionText)
    }
    
}
