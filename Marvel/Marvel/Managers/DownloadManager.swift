//
//  DownloadManager.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 18/12/2020.
//  Copyright © 2020 Javi Castillo Risco. All rights reserved.
//

import Foundation

protocol DownloadManager {

    func getUrlRequest(_ url: URL, params: NSDictionary) -> URL
    func downloadData(_ url: URL, offset: Int, category: Constants.TypeData)
    func downloadImage(_ item: ItemMarvel)
    func stopTasks()
    
}
