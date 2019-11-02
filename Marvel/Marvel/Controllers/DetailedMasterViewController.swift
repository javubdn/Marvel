//
//  DetailedMasterViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 21/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit

class DetailedMasterViewController: UITableViewController {
    
    var items = [ItemMarvel]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredItems = [ItemMarvel]()
    var presenter: DetailedMasterPresenter!
    
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
        
        //We prepare the notifications of the view
        NotificationCenter.default.addObserver(self, selector: #selector(imageDownloaded(_:)), name:NSNotification.Name(rawValue: Constants.NOTIFICATION_IMAGE_DOWNLOADED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable(_:)), name:NSNotification.Name(rawValue: Constants.NOTIFICATION_UPDATE_DATA), object: nil)
        
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		
		//We stop the downloads, if there is anything
		DownloadManager.sharedInstance.stopTasks()
		
        //We delete the notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return resultSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = items.filter({( item: ItemMarvel) -> Bool in
            return item.mainText.lowercased().contains(searchText.lowercased())
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
    @objc func updateTable(_ notification: Notification) {
		
		//We get the items from the notification
        guard let chunkResults = notification.object as? [[String: Any]] else {
            return
        }

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
        case .none:
            return
        }
        StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
        items += itemsDownloaded
        itemsTableView.reloadData()
        
    }
    
    /// This method is called when we have a new image. We must, in this case, update the table
    ///
    /// - Parameter notification: notification
    @objc func imageDownloaded(_ notification: Notification) {
        guard let item = notification.object as? ItemMarvel else {
            return
        }
        
        if self.resultSearchController.isActive {
            if let rowNumber = filteredItems.index(where: {$0 === item}) {
                let indexPath = IndexPath(row: rowNumber, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            if let rowNumber = items.index(where: {$0 === item}) {
                let indexPath = IndexPath(row: rowNumber, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        } else {
            return items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let item: ItemMarvel
        if isFiltering() {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        
        (cell.contentView.viewWithTag(1) as! UILabel).text = item.mainText
        (cell.contentView.viewWithTag(2) as! UIImageView).image = item.imageThumbnail
        if item.imageDownloaded {
            (cell.contentView.viewWithTag(3) as! UIActivityIndicatorView).stopAnimating()
        } else {
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
        guard let indexPath = tableView.indexPathForSelectedRow,
            let viewController = segue.destination as? ItemDetailViewController else {
            return
        }
        
        if isFiltering() {
            viewController.itemMarvel = filteredItems[indexPath.row]
        } else {
            viewController.itemMarvel = items[indexPath.row]
        }
    }
    
}

extension DetailedMasterViewController: DetailedMasterPresenterOutput {

    func updateItems(_ items: [ItemMarvel]) {
        self.items.removeAll()
        self.items += items
    }

}

extension DetailedMasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filterContentForSearchText(searchText)
    }
    
}

