//
//  StoryDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class StoryDetailViewController: UIViewController {
    
    var story:Story = Story()
	
    @IBOutlet weak var descriptionStory: UILabel!
    @IBOutlet weak var imageStory: UIImageView!
    
    override func viewDidLoad() {
        if(self.story.title.isEmpty) {
            descriptionStory.text = "Description not available"
        }
        else {
            descriptionStory.text = self.story.title
        }
        imageStory.contentMode = UIViewContentMode.ScaleAspectFit;
        imageStory.image = self.story.imageThumbnail
    }
    
}