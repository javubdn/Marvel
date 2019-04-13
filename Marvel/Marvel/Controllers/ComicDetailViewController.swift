//
//  ComicDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class ComicDetailViewController: UIViewController {
    
    var comic:Comic = Comic()
    
    @IBOutlet weak var titleComic: UILabel!
    @IBOutlet weak var descriptionComic: UILabel!
    @IBOutlet weak var imageComic: UIImageView!
    
    override func viewDidLoad() {
        titleComic.text = self.comic.title
        if(self.comic.descriptionComic.isEmpty) {
            descriptionComic.text = "Description not available"
        }
        else {
            descriptionComic.text = self.comic.descriptionComic
        }
        imageComic.contentMode = UIView.ContentMode.scaleAspectFit;
        imageComic.image = self.comic.imageThumbnail
    }
    
}
