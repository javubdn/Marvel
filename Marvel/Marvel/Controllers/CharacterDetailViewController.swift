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
    
    override func viewDidLoad() {
        self.nameCharacter.text = character.name
        self.descriptionCharacter.text = character.descriptionCharacter
    }
    
}