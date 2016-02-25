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
class Creator:NSObject {

	var id:Int64
	var firstName:String
	var fullName:String
	var lastName:String
	var middleName:String
	var modified:NSDate
	var resourceURI:String
	var suffix:String
    var thumbnail:String
    var imageThumbnail:UIImage
	
	override init() {
		id = 0
		firstName = ""
		fullName = ""
		lastName = ""
		middleName = ""
		modified = NSDate()
		resourceURI = ""
		suffix = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
	
}
