//
//  ItemMarvel.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 26/3/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

/// Class that contain the data of a Character
class ItemMarvel:NSObject {
    var id:Int64
    var thumbnail:String
    var imageDownloaded:Bool
    var imageThumbnail:UIImage
    
    override init() {
        id = 0
        thumbnail = ""
        imageDownloaded = false
        imageThumbnail = UIImage()
    }
    
}