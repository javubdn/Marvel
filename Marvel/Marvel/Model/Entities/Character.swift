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
class Character:ItemMarvel {
	var name:String
	var descriptionCharacter:String
	var modified:Date
	var resourceURI:String
    
	override init() {
		name = ""
		descriptionCharacter = ""
		modified = Date()
		resourceURI = ""
	}
    
}
