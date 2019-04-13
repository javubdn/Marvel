//
//  CreatorDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class CreatorDetailViewController: UIViewController {
    
    var creator:Creator = Creator()
    @IBOutlet weak var firstNameCreator: UILabel!
    @IBOutlet weak var lastNameCreator: UILabel!
    @IBOutlet weak var imageCreator: UIImageView!
    
    override func viewDidLoad() {
        firstNameCreator.text = self.creator.firstName
        lastNameCreator.text = self.creator.lastName
        imageCreator.contentMode = UIView.ContentMode.scaleAspectFit;
        imageCreator.image = self.creator.imageThumbnail
    }
    
}
