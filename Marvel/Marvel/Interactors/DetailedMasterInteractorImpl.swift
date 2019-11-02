//
//  DetailedMasterInteractorImpl.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 02/11/2019.
//  Copyright © 2019 Javi Castillo Risco. All rights reserved.
//

import Foundation

class DetailedMasterInteractorImpl: DetailedMasterInteractor {
    
    var delegate: DetailedMasterInteractorOutput!
    
    var category: Constants.TypeData
    
    var items: [ItemMarvel]?
    
    init(category: Constants.TypeData) {
        self.category = category
    }
    
    func loadData() {
        guard items == nil else {
            delegate.updateItems(items!)
            for item in items! {
                if !(item.imageDownloaded) {
                    DownloadManager.downloadImage(item)
                }
            }
            return
        }
        items = StorageManager.sharedInstance.getItems(category)
        if let items = items {
            delegate.updateItems(items)
            for item in items {
                if !(item.imageDownloaded) {
                    DownloadManager.downloadImage(item)
                }
            }
        }
        let count = items?.count ?? 0
        let total = StorageManager.sharedInstance.getNumberItems(category)
        
        if total == 0 || count < total {
            //In this case we don't have elements, we init the download
            let url = getUrl()
            DownloadManager.sharedInstance.downloadData(URL(fileURLWithPath: url), offset:count, category: category)
        }
    }
    
}

extension DetailedMasterInteractorImpl {
    
    private func getUrl() -> String {
        var url = "http://gateway.marvel.com/v1/public/"
        url = url + category.getDescription()
        return url
    }
    
}
