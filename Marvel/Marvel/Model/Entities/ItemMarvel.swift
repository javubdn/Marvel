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
class ItemMarvel {
    
    let id: Int64
    let thumbnail: String?
    let mainText: String
    let descriptionText: String
    var imageDownloaded = false
    var imageThumbnail: UIImage?
    
    init(id: Int64, thumbnail: String?, mainText: String, descriptionText: String) {
        self.id = id
        self.thumbnail = thumbnail
        self.mainText = mainText
        self.descriptionText = descriptionText
    }
    
}
