//
//  SerieDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class SerieDetailViewController: UIViewController {
    
    var serie:Serie = Serie()
    
    @IBOutlet weak var titleSerie: UILabel!
    @IBOutlet weak var descriptionSerie: UILabel!
    @IBOutlet weak var imageSerie: UIImageView!
    
    override func viewDidLoad() {
        titleSerie.text = self.serie.title
        if(self.serie.descriptionSerie.isEmpty) {
            descriptionSerie.text = "Description not available"
        }
        else {
            descriptionSerie.text = self.serie.descriptionSerie
        }
        imageSerie.contentMode = UIViewContentMode.scaleAspectFit;
        imageSerie.image = self.serie.imageThumbnail
    }
    
}
