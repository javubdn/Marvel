//
//  DetailedMasterInteractor.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 02/11/2019.
//  Copyright © 2019 Javi Castillo Risco. All rights reserved.
//

import Foundation

protocol DetailedMasterInteractor {
    func loadData()
    func updateData()
    func stopTasks()
}

protocol DetailedMasterInteractorOutput {
    func updateItems(_ items: [ItemMarvel])
    func imageDownloaded(_ item: ItemMarvel)
}
