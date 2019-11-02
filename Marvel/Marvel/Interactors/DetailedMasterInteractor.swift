//
//  DetailedMasterInteractor.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 02/11/2019.
//  Copyright © 2019 Javi Castillo Risco. All rights reserved.
//

import Foundation

protocol DetailedMasterInteractor {
    var category: Constants.TypeData {get set}
    func loadData()
}

protocol DetailedMasterInteractorOutput {
    func updateItems(_ items: [ItemMarvel])
}
