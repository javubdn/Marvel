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
    
    var items:NSMutableArray = NSMutableArray()
    var resultSearchController = UISearchController()
    var filteredItems = NSMutableArray()
    
    @IBOutlet var itemsTableView: UITableView!
    var category: Constants.TypeData = Constants.TypeData.Characters {
        didSet {
            // Update the view.
           // self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.Black
            controller.searchBar.barTintColor = UIColor.whiteColor()
            controller.searchBar.backgroundColor = UIColor.clearColor()
            self.itemsTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //We prepare the notifications of the view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloaded:", name:Constants.NOTIFICATION_IMAGE_DOWNLOADED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name:Constants.NOTIFICATION_UPDATE_DATA, object: nil)
        
        let elementsDB = StorageManager.sharedInstance.getItems(self.category)
        if(self.items.count == 0) {
            self.items.addObjectsFromArray(elementsDB as [AnyObject])
        }
        //itemsTableView.reloadData()
        
        let count = self.items.count //We have here the number of items that we have stored
        let total = StorageManager.sharedInstance.getNumberItems(self.category) // We have here the number of items that we should have
        
        if(total == 0 || count < total) {
            
            //In this case we don't have elements, we init the download
            let url = self.getUrl()
            let manager = DownloadManager.sharedInstance
            manager.downloadData(NSURL(fileURLWithPath: url), offset:count, category: self.category )
        
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //We delete the notifications
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Private methods
    
    func getUrl()->String {
        
        var url = "http://gateway.marvel.com/v1/public/"
        
        url = url + self.category.getDescription()
        
        return url
        
    }
    
    // MARK: - Notifications
    
    func updateTable(notification: NSNotification){
		
		//We get the items from the notification
        let chunkResults = notification.object as? NSArray
		
		//We store the items
        switch(self.category) {
        case .Characters:
            let itemsDownloaded = Character.getCharactersWithArrayDictionaries(chunkResults!)
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
            self.items.addObjectsFromArray(itemsDownloaded)
            break
        case .Comics:
            let itemsDownloaded = Comic.getComicsWithArrayDictionaries(chunkResults!)
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
            self.items.addObjectsFromArray(itemsDownloaded)
            break
        case .Creators:
            let itemsDownloaded = Creator.getCreatorsWithArrayDictionaries(chunkResults!)
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
            self.items.addObjectsFromArray(itemsDownloaded)
            break
        case .Events:
            let itemsDownloaded = Event.getEventsWithArrayDictionaries(chunkResults!)
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
            self.items.addObjectsFromArray(itemsDownloaded)
            break
        case .Series:
            let itemsDownloaded = Serie.getSeriesWithArrayDictionaries(chunkResults!)
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
            self.items.addObjectsFromArray(itemsDownloaded)
            break
        case .Stories:
            let itemsDownloaded = Story.getStoriesWithArrayDictionaries(chunkResults!)
            StorageManager.sharedInstance.saveListItems(itemsDownloaded, category: self.category)
            self.items.addObjectsFromArray(itemsDownloaded)
            break
        default:
            break
        }
        
        self.itemsTableView.reloadData()
        
    }
    
    func imageDownloaded(notification: NSNotification) {
        
        //We need update the tableView
        self.itemsTableView.reloadData()
    }
    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredItems.count
        }
        else {
            return self.items.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
        
        let object:AnyObject
        if (self.resultSearchController.active) {
            object = filteredItems[indexPath.row]
        }
        else {
            object = items[indexPath.row]
        }
        
        //(cell.contentView.viewWithTag(1) as! UILabel).text = object["name"] as? String
        
        switch(self.category) {
        case .Characters:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Character).name
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Character).imageThumbnail
            break
        case .Comics:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Comic).title
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Comic).imageThumbnail
            break
        case .Creators:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Creator).fullName
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Creator).imageThumbnail
            break
        case .Events:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Event).title
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Event).imageThumbnail
            break
        case .Series:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Serie).title
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Serie).imageThumbnail
            break
        case .Stories:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Story).title
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Story).imageThumbnail
            break
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(self.category) {
        case .Characters:
            performSegueWithIdentifier("showCharacter", sender: self)
            break
        case .Comics:
            performSegueWithIdentifier("showComic", sender: self)
            break
        case .Creators:
            performSegueWithIdentifier("showCreator", sender: self)
            break
        case .Events:
            performSegueWithIdentifier("showEvent", sender: self)
            break
        case .Series:
            performSegueWithIdentifier("showSerie", sender: self)
            break
        case .Stories:
            performSegueWithIdentifier("showStory", sender: self)
            break
        default:
            break
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch(segue.identifier!) {
            case "showCharacter":
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    let viewController:CharacterDetailViewController = segue.destinationViewController as! CharacterDetailViewController
                    
                    if (self.resultSearchController.active) {
                        let character = filteredItems[indexPath.row] as! Character
                        viewController.character = character
                    }
                    else {
                        let character = items[indexPath.row] as! Character
                        viewController.character = character
                    }
                    
                }
            break
        case "showComic":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:ComicDetailViewController = segue.destinationViewController as! ComicDetailViewController
                
                if (self.resultSearchController.active) {
                    let comic = filteredItems[indexPath.row] as! Comic
                    viewController.comic = comic
                }
                else {
                    let comic = items[indexPath.row] as! Comic
                    viewController.comic = comic
                }
                
            }
            break
        case "showCreator":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:CreatorDetailViewController = segue.destinationViewController as! CreatorDetailViewController
                
                if (self.resultSearchController.active) {
                    let creator = filteredItems[indexPath.row] as! Creator
                    viewController.creator = creator
                }
                else {
                    let creator = items[indexPath.row] as! Creator
                    viewController.creator = creator
                }
                
            }
            break
        case "showEvent":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:EventDetailViewController = segue.destinationViewController as! EventDetailViewController
                
                if (self.resultSearchController.active) {
                    let event = filteredItems[indexPath.row] as! Event
                    viewController.event = event
                }
                else {
                    let event = items[indexPath.row] as! Event
                    viewController.event = event
                }
                
            }
            break
        case "showSerie":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:SerieDetailViewController = segue.destinationViewController as! SerieDetailViewController
                
                if (self.resultSearchController.active) {
                    let serie = filteredItems[indexPath.row] as! Serie
                    viewController.serie = serie
                }
                else {
                    let serie = items[indexPath.row] as! Serie
                    viewController.serie = serie
                }
                
            }
            break
        case "showStory":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:StoryDetailViewController = segue.destinationViewController as! StoryDetailViewController
                
                if (self.resultSearchController.active) {
                    let story = filteredItems[indexPath.row] as! Story
                    viewController.story = story
                }
                else {
                    let story = items[indexPath.row] as! Story
                    viewController.story = story
                }
                
            }
            break
        default:
            break
            
            
        }
        if segue.identifier == "showCharacter" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:CharacterDetailViewController = segue.destinationViewController as! CharacterDetailViewController
                let character = items[indexPath.row] as! Character
                viewController.character = character
                
                if (self.resultSearchController.active) {
                    let character = filteredItems[indexPath.row] as! Character
                    viewController.character = character
                }
                else {
                    let character = items[indexPath.row] as! Character
                    viewController.character = character
                }
                
            }
        }
    }
    
    // MARK: - UISearchResultsUpdating protocol
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.filteredItems.removeAllObjects()
        
        let searchPredicate:NSPredicate
        
        switch(self.category) {
        case .Characters:
            searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchController.searchBar.text!)
            break
        case .Comics:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
            break
        case .Creators:
            searchPredicate = NSPredicate(format: "SELF.fullName CONTAINS[c] %@", searchController.searchBar.text!)
            break
        case .Events:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
            break
        case .Series:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
            break
        case .Stories:
            searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
            break
        default:
            searchPredicate = NSPredicate()
            break
        }
        
        let itemsCurrent = (self.items as NSArray)
        let array = itemsCurrent.filteredArrayUsingPredicate(searchPredicate)
        self.filteredItems.addObjectsFromArray(array)
        self.tableView.reloadData()
        
    }
    
}
