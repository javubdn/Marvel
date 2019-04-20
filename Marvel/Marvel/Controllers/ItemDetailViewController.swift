//
//  ItemDetailViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 14/04/2019.
//  Copyright © 2019 Javi Castillo Risco. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionValue: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    
    var itemMarvel: ItemMarvel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleValue.text = itemMarvel?.mainText
        descriptionValue.text = itemMarvel?.descriptionText
        imageItem.image = itemMarvel?.imageThumbnail
    }

}
