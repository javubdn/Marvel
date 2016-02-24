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
        descriptionCharacter.text = self.character.descriptionCharacter
        imageCharacter.image = character.imageThumbnail
    }
    
}