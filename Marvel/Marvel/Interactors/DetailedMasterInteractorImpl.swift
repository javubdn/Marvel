//
//  DetailedMasterInteractorImpl.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 02/11/2019.
//  Copyright © 2019 Javi Castillo Risco. All rights reserved.
//

import Foundation

class DetailedMasterInteractorImpl: DetailedMasterInteractor {

    private let downloadManager: DownloadManager
    var delegate: DetailedMasterInteractorOutput!
    
    private let category: Constants.TypeData
    private var numberItems = 0
    private var currentCount = 0
    private var items: [ItemMarvel] = []
    
    init(downloadManager: DownloadManager, category: Constants.TypeData) {
        self.downloadManager = downloadManager
        self.category = category
    }
    
    func loadData() {
        items = StorageManager.sharedInstance.getItems(category)
        delegate.updateItems(items)
    }

    func updateData() {
        for item in items {
            if !item.imageDownloaded {
                downloadManager.downloadImage(item)
            }
        }
        currentCount = items.count
        numberItems = StorageManager.sharedInstance.getNumberItems(category)
        if numberItems == 0 || currentCount < numberItems {
            //In this case we don't have elements, we init the download
            let url = getUrl()
            downloadManager.downloadData(URL(fileURLWithPath: url), offset: currentCount, category: category)
        }
    }

    func stopTasks() {
        downloadManager.stopTasks()
    }
    
}

extension DetailedMasterInteractorImpl {
    
    private func getUrl() -> String {
        var url = "http://gateway.marvel.com/v1/public/"
        url = url + category.getDescription()
        return url
    }
    
}

extension DetailedMasterInteractorImpl: DownloadManagerDelegate {

    func imageDownloaded(_ item: ItemMarvel) {
        delegate.imageDownloaded(item)
    }

    func infoDownloaded(info: [String: Any]) {
        if let total = info["total"] as? CLong, numberItems != total {
            numberItems = total
            StorageManager.sharedInstance.updateNumberItems(category, numItems: numberItems)
        }
        if let chunkResults = info["results"] as? [[String: Any]] {
            currentCount += chunkResults.count
            var itemsDownloaded: [ItemMarvel]
            //We store the items
            switch self.category {
            case .characters:
                itemsDownloaded = CharactersFactory.getCharactersWithArrayDictionaries(chunkResults)
            case .comics:
                itemsDownloaded = ComicsFactory.getComicsWithArrayDictionaries(chunkResults)
            case .creators:
                itemsDownloaded = CreatorsFactory.getCreatorsWithArrayDictionaries(chunkResults)
            case .events:
                itemsDownloaded = EventsFactory.getEventsWithArrayDictionaries(chunkResults)
            case .series:
                itemsDownloaded = SeriesFactory.getSeriesWithArrayDictionaries(chunkResults)
            case .stories:
                itemsDownloaded = StoriesFactory.getStoriesWithArrayDictionaries(chunkResults)
            }
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: category)
            items += itemsDownloaded
            delegate.updateItems(items)
            for item in itemsDownloaded {
                downloadManager.downloadImage(item)
            }
        }
        if currentCount < numberItems {
            //If the count until this point is less than the number of items that we are expecting, we update the offset and continue with the downloading
            let url = getUrl()
            downloadManager.downloadData(URL(fileURLWithPath: url), offset: currentCount, category: category)
        }
    }

}
