//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 22/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    
    var character:Character = Character()
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var descriptionCharacter: UILabel!
    @IBOutlet weak var imageCharacter: UIImageView!
    
    override func viewDidLoad() {
        nameCharacter.text = self.character.name
        if(self.character.descriptionCharacter.isEmpty) {
            descriptionCharacter.text = "Description not available"
        }
        else {
            descriptionCharacter.text = self.character.descriptionCharacter
        }
		imageCharacter.contentMode = UIViewContentMode.scaleAspectFit;
        imageCharacter.image = character.imageThumbnail
    }
    
}
