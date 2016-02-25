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

class Character:NSObject {
	var id:Int64
	var name:String
	var descriptionCharacter:String
	var modified:NSDate
	var resourceURI:String
    var thumbnail:String
    var imageThumbnail:UIImage
    
	override init() {
		id = 0
		name = ""
		descriptionCharacter = ""
		modified = NSDate()
		resourceURI = ""
        thumbnail = ""
        imageThumbnail = UIImage()
	}
    
}
