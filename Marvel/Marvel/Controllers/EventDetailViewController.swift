//
//  EventDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController {
    
    var event:Event = Event()
    
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var descriptionEvent: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!
    
    override func viewDidLoad() {
        titleEvent.text = self.event.title
        if(self.event.descriptionEvent.isEmpty) {
            descriptionEvent.text = "Description not available"
        }
        else {
            descriptionEvent.text = self.event.descriptionEvent
        }
        imageEvent.contentMode = UIViewContentMode.scaleAspectFit;
        imageEvent.image = self.event.imageThumbnail
    }
    
}
