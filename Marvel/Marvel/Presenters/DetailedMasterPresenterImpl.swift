//
//  DetailedMasterPresenterImpl.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 02/11/2019.
//  Copyright © 2019 Javi Castillo Risco. All rights reserved.
//

import Foundation

class DetailedMasterPresenterImpl: DetailedMasterPresenter {
    var interactor: DetailedMasterInteractor
    var delegate: DetailedMasterPresenterOutput
    
    init(interactor: DetailedMasterInteractor, delegate: DetailedMasterPresenterOutput) {
        self.interactor = interactor
        self.delegate = delegate
    }
    
    func loadData() {
        interactor.loadData()
    }
}

extension DetailedMasterPresenterImpl: DetailedMasterInteractorOutput {
    
    func updateItems(_ items: [ItemMarvel]) {
        delegate.updateItems(items)
    }
    
}
