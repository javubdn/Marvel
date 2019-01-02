//
//  DetailedMasterViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 21/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class DetailedMasterViewController: UITableViewController, UISearchResultsUpdating {
    
    var items = [AnyObject]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredItems = [AnyObject]()
    
    @IBOutlet var itemsTableView: UITableView!
    var category: Constants.TypeData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.barStyle = UIBarStyle.black
        resultSearchController.searchBar.barTintColor = UIColor.white
        resultSearchController.searchBar.backgroundColor = UIColor.clear
        self.itemsTableView.tableHeaderView = resultSearchController.searchBar
        definesPresentationContext = true
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //We prepare the notifications of the view
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedMasterViewController.imageDownloaded(_:)), name:NSNotification.Name(rawValue: Constants.NOTIFICATION_IMAGE_DOWNLOADED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedMasterViewController.updateTable(_:)), name:NSNotification.Name(rawValue: Constants.NOTIFICATION_UPDATE_DATA), object: nil)
        
        let elementsDB = StorageManager.sharedInstance.getItems(self.category)
		items.removeAll()
        items += elementsDB

        //itemsTableView.reloadData()
        
        let count = self.items.count //We have here the number of items that we have stored
        let total = StorageManager.sharedInstance.getNumberItems(self.category) // We have here the number of items that we should have
        
        if total == 0 || count < total {
            //In this case we don't have elements, we init the download
            let url = self.getUrl()
            DownloadManager.sharedInstance.downloadData(URL(fileURLWithPath: url), offset:count, category: self.category )
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		
		//We stop the downloads, if there is anything
		DownloadManager.sharedInstance.stopTasks()
		
        //We delete the notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    /**
    This method gets the url that we need to download the data of the current category (Characters, comics, etc...)
    
    - returns: The string of the url to make the request
    */
    private func getUrl() -> String {
        var url = "http://gateway.marvel.com/v1/public/"
        url = url + self.category.getDescription()
        return url
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return resultSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = items.filter({( item: AnyObject) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        itemsTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return resultSearchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Notifications
    
    /// This method updates the table with the data obtained in the request to Marvel's Api and it stores this data in the database
    ///
    /// - Parameter notification: notification
    func updateTable(_ notification: Notification) {
		
		//We get the items from the notification
        let chunkResults = notification.object as? [[String: Any]]
        var itemsDownloaded: [AnyObject]
		//We store the items
        switch self.category! {
        case .characters:
            itemsDownloaded = CharactersFactory.getCharactersWithArrayDictionaries(chunkResults!)
        case .comics:
            itemsDownloaded = ComicsFactory.getComicsWithArrayDictionaries(chunkResults!)
        case .creators:
            itemsDownloaded = CreatorsFactory.getCreatorsWithArrayDictionaries(chunkResults!)
        case .events:
            itemsDownloaded = EventsFactory.getEventsWithArrayDictionaries(chunkResults!)
        case .series:
            itemsDownloaded = SeriesFactory.getSeriesWithArrayDictionaries(chunkResults!)
        case .stories:
            itemsDownloaded = StoriesFactory.getStoriesWithArrayDictionaries(chunkResults!)
        }
        StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
        items += itemsDownloaded
        itemsTableView.reloadData()
        
    }
    
    /// This method is called when we have a new image. We must, in this case, update the table
    ///
    /// - Parameter notification: notification
    func imageDownloaded(_ notification: Notification) {
        let item = notification.object
        
        if self.resultSearchController.isActive {
            if let rowNumber = filteredItems.index(where: {$0 === (item as AnyObject!)}) {
                let indexPath = IndexPath(row: rowNumber, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
            }
        } else {
            if let rowNumber = items.index(where: {$0 === (item as AnyObject!)}) {
                let indexPath = IndexPath(row: rowNumber, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
            }
        }
        
        //We need update the tableView
        //self.itemsTableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filteredItems.count
        } else {
            return self.items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let object:AnyObject
        if isFiltering() {
            object = filteredItems[indexPath.row] as AnyObject
        } else {
            object = items[indexPath.row] as AnyObject
        }
        
        //(cell.contentView.viewWithTag(1) as! UILabel).text = object["name"] as? String
        
        switch self.category! {
        case .characters:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Character).name
            break
        case .comics:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Comic).title
            break
        case .creators:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Creator).fullName
            break
        case .events:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Event).title
            break
        case .series:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Serie).title
            break
        case .stories:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Story).title
            break
        }
        
        (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! ItemMarvel).imageThumbnail
        if((object as! ItemMarvel).imageDownloaded) {
            (cell.contentView.viewWithTag(3) as! UIActivityIndicatorView).stopAnimating()
        }
        else {
            if(!(cell.contentView.viewWithTag(3) as! UIActivityIndicatorView).isAnimating) {
                (cell.contentView.viewWithTag(3) as! UIActivityIndicatorView).startAnimating()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: self.category.getSegue(), sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier!) {
        case Constants.TypeData.characters.getSegue():
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! CharacterDetailViewController
                if isFiltering() {
                    let character = filteredItems[indexPath.row] as! Character
                    viewController.character = character
                } else {
                    let character = items[indexPath.row] as! Character
                    viewController.character = character
                }
            }
        case Constants.TypeData.comics.getSegue():
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! ComicDetailViewController
                if isFiltering() {
                    let comic = filteredItems[indexPath.row] as! Comic
                    viewController.comic = comic
                } else {
                    let comic = items[indexPath.row] as! Comic
                    viewController.comic = comic
                }
            }
        case Constants.TypeData.creators.getSegue():
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! CreatorDetailViewController
                if isFiltering() {
                    let creator = filteredItems[indexPath.row] as! Creator
                    viewController.creator = creator
                } else {
                    let creator = items[indexPath.row] as! Creator
                    viewController.creator = creator
                }
            }
        case Constants.TypeData.events.getSegue():
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! EventDetailViewController
                if isFiltering() {
                    let event = filteredItems[indexPath.row] as! Event
                    viewController.event = event
                } else {
                    let event = items[indexPath.row] as! Event
                    viewController.event = event
                }
            }
        case Constants.TypeData.series.getSegue():
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! SerieDetailViewController
                if isFiltering() {
                    let serie = filteredItems[indexPath.row] as! Serie
                    viewController.serie = serie
                } else {
                    let serie = items[indexPath.row] as! Serie
                    viewController.serie = serie
                }
            }
        case Constants.TypeData.stories.getSegue():
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! StoryDetailViewController
                if isFiltering() {
                    let story = filteredItems[indexPath.row] as! Story
                    viewController.story = story
                } else {
                    let story = items[indexPath.row] as! Story
                    viewController.story = story
                }
            }
        default:
            break
        }
    }
    
    // MARK: - UISearchResultsUpdating protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        /*
        self.filteredItems.removeAll()
        let searchPredicate:NSPredicate
        switch self.category! {
        case .characters:
            searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchController.searchBar.text!)
        case .comics:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
        case .creators:
            searchPredicate = NSPredicate(format: "SELF.fullName CONTAINS[c] %@", searchController.searchBar.text!)
        case .events:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
        case .series:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
        case .stories:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
        }
        let itemsCurrent = self.items as NSArray
        let array = itemsCurrent.filtered(using: searchPredicate)
        filteredItems.append(contentsOf: array)
        tableView.reloadData()
 */
    }
    
}

