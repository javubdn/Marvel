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

	var firstName:String
	var fullName:String
	var lastName:String
	var middleName:String
	var modified:Date
	var resourceURI:String
	var suffix:String
	
	override init() {
		firstName = ""
		fullName = ""
		lastName = ""
		middleName = ""
		modified = Date()
		resourceURI = ""
		suffix = ""
	}
	
}
