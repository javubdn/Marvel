//
//  DownloadManager.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 20/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class DownloadManager {
    
    //This will be the instance for DownloadManager, this is a Singleton class
    static let sharedInstance = DownloadManager()
    
    static let LIMIT_RATE_EXCEDED_CODE = 429
    static let DOWNLOAD_CANCELLED_CODE = -999
    
    let queue: OperationQueue
    var publicAPIKey: String     // Public key of the Marvel API
    var privateAPIKey: String    // Private key of the Marvel API
    var url: URL?               // We keep here the current URL that we are using for the download
    var offset: CLong            // We store here the current offset, we use it to know in what point we have the current request
    var numberOfItems: CLong     // We store here the number of items that must be downloaded (we use it to know when the download is completed)
    var count: CLong             // Indicates the number of items downloaded in this moment (we use it to know if we have finished)
    var category: Constants.TypeData! //It keeps the type of category to update the number of items if it's necessary

    //Data received in every call
    var attributionText: String
    var attributionHTML: String
    var copyright: String
    var etag: String
    
    init() {
        queue = OperationQueue()
        publicAPIKey = ""
        privateAPIKey = ""
        attributionText = ""
        attributionHTML = ""
        copyright = ""
        etag = ""
        offset = 0
        numberOfItems = 0
        count = 0
    }
    
    // MARK: - Download data
    
    /**
    This function gets the URL that we need to make the request. In this method the needed data for the request is added (like timestamp or hash code)
    
    - parameter url:    url we want to make the request
    - parameter params: params with extra info to make the request (like offset)
    
    - returns: url with the data needed (like hash or timestamp)
    */
    func getUrlRequest(_ url: URL, params: NSDictionary) -> URL {
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        let timeStamp = Int(Date().timeIntervalSinceReferenceDate)
        let hashBase = "\(timeStamp)\(privateAPIKey)\(publicAPIKey)"
        let hash = hashBase.md5()
        
        var query = ""                                      //This query contains the data needed for the request to Marvel API
        query += "ts=\(timeStamp)"                          //We add the timestamp
        query += "&hash=\(hash)"                            //We add the md5 hash for the validation of the user
        query += "&apikey=\(publicAPIKey)"                  //We add the public key
        
        if(params["offset"] != nil) {
            query += "&offset=\(params["offset"] as! CLong)"          //If exists offset, we add it to the request
        }
        
        components.query = query                           //We assign the query to our urlComponents
        
        return components.url ?? url
        
    }
    
    /**
     This method inits the download of the data from Marvel API using the url given
     
     - parameter url:      url to make the request
     - parameter offset:   offset of the request
     - parameter category: type of item (character, comic, etc...)
     */
    func downloadData(_ url: URL, offset: Int, category: Constants.TypeData) {
        
        self.url = url              // We update the url with the given in the function
        self.offset = offset        // We init the offset with value that give us the function
        self.numberOfItems = 20     // We put 20 because is the number of items that can be loaded in every call, this number will be updated in the first request if the total is bigger than 20
        self.count = offset         //We init the counter with the same value that the offset
        self.category = category    //We save the category to use it to update the number of items of the category
        self.continueDownloading()  //We make the call to continueDownloading to init the download (the first time the offset is 0)
		
    }
    
    /**
     This method is called recursively to get the data of the request
     Once the method is called, it gets all the data until we have all achieved
     */
    func continueDownloading() {
        
        //We prepare the params that we need
        var params = Dictionary<String, CLong>()
        if(self.offset > 0) {
            params["offset"] = self.offset
        }
        
        let currentUrl = getUrlRequest(self.url!, params: params as NSDictionary)
        
        //Once we have the url with all the data we need, we make the request
        let task = URLSession.shared.dataTask(with: currentUrl, completionHandler: { data, response, error in
            if error == nil {
				//We need to check if there is any error code in the response
                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    return
                }
				let statusCode = httpUrlResponse.statusCode
				switch (statusCode) {
                case DownloadManager.LIMIT_RATE_EXCEDED_CODE:
                    //TODO: We should give a message to the user indicating that the maximum of requests has been achieved
					return;
				default:
					break;
				}
				do {
                    guard let data = data,
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                            print("Error could not parse JSON")
                            return
                    }
                    
                    if let attributionText = json["attributionText"] as? String {
                        self.attributionText = attributionText
                    }
                    if let attributionHTML = json["attributionHTML"] as? String {
                        self.attributionHTML = attributionHTML
                    }
                    if let copyright = json["copyright"] as? String {
                        self.copyright = copyright
                    }
                    if let etag = json["etag"] as? String {
                        self.etag = etag
                    }
                    
                    if let data = json["data"] as? [String: Any] {
                        if let total = data["total"] as? CLong {
                            self.numberOfItems = total
                            StorageManager.sharedInstance.updateNumberItems(self.category, numItems: self.numberOfItems)
                        }
                        if let chunkResults = data["results"] as? NSArray {
                            self.count += chunkResults.count
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NOTIFICATION_UPDATE_DATA), object: chunkResults)
                        }
                    }
                    
                    if (self.count < self.numberOfItems) {
                        //If the count until this point is less than the number of items that we are expecting, we update the offset and continue with the downloading
                        self.offset = self.count;
                        self.continueDownloading()
                    }
                } catch let parseError {
                    print(parseError)
                }
            }
        })
        task.resume()
    }
    
    // MARK: - Download images
    
     /**
     This function is used to download the images of the thumbnails from the urls
     
     - parameter item:     item that contains the image we want to download
     - parameter category: type of item
     */
    static func downloadImage(_ item: ItemMarvel) {
        guard let thumbnail = item.thumbnail,
            let url = URL(string: thumbnail) else {
                item.imageDownloaded = true
                item.imageThumbnail = UIImage(named: "ItemNotAvailable")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NOTIFICATION_IMAGE_DOWNLOADED), object: item)
                return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async { () -> Void in
                guard let data = data, error == nil else {
                    if let errorCode = error as NSError?, errorCode.code != DOWNLOAD_CANCELLED_CODE {
                        item.imageDownloaded = true
                        item.imageThumbnail = UIImage(named: "ItemNotAvailable")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NOTIFICATION_IMAGE_DOWNLOADED), object: item)
                    }
                    return
                }
                item.imageThumbnail = UIImage(data: data)!
                item.imageDownloaded = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NOTIFICATION_IMAGE_DOWNLOADED), object: item)
            }
        }).resume()
    }
	
    // MARK: - Stop tasks
    
    /**
     This method stops the tasks that can be in this moment in execution. It's called when the screen of detail is closed and we don't need download more data
     */
	func stopTasks() {
		URLSession.shared.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
			for task in dataTasks {
				task.cancel()
			}
		}
	}
	
}
