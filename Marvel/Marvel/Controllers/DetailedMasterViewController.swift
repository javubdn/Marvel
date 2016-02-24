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
    
    var items:NSMutableArray = NSMutableArray()
    
    @IBOutlet var itemsTableView: UITableView!
    var category: Constants.TypeData = Constants.TypeData.Characters {
        didSet {
            // Update the view.
           // self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        //WE prepare the notifications of the view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloaded:", name:Constants.NOTIFICATION_IMAGE_DOWNLOADED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name:Constants.NOTIFICATION_UPDATE_DATA, object: nil)
		
        let elementsDB = StorageManager.sharedInstance.getItems(self.category)
        self.items.addObjectsFromArray(elementsDB as [AnyObject])
        itemsTableView.reloadData()
        
        let count = self.items.count //We have here the number of items that we have stored
        let total = StorageManager.sharedInstance.getNumberItems(self.category) // We have here the number of items that we should have
        
        if(total == 0 || count < total) {
            //In this case we don't have elements, we init the download
            
            let url = self.getUrl()
            let manager = DownloadManager.sharedInstance
            manager.downloadData(NSURL(fileURLWithPath: url), offset:count, category: self.category )
            
        }
      	
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
		let characters = Character.getCharactersWithArrayDictionaries(chunkResults!)
		StorageManager.sharedInstance.saveCharactersList(characters)
		
		//We add the items to the list of items
        //self.items.addObjectsFromArray((chunkResults! as NSArray) as [AnyObject])
		self.items.addObjectsFromArray(characters)
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
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
        
        let object = items[indexPath.row]
        //(cell.contentView.viewWithTag(1) as! UILabel).text = object["name"] as? String
        
        switch(self.category) {
        case .Characters:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Character).name
            (cell.contentView.viewWithTag(2) as! UIImageView).image = (object as! Character).imageThumbnail
            break
        case .Comics:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Comic).title
            break
        case .Creators:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Creator).fullName
            break
        case .Events:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Event).title
            break
        case .Series:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Serie).title
            break
        case .Stories:
            (cell.contentView.viewWithTag(1) as! UILabel).text = (object as! Story).title
            break
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showCharacter", sender: self)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCharacter" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:CharacterDetailViewController = segue.destinationViewController as! CharacterDetailViewController
                let character = items[indexPath.row] as! Character
                viewController.character = character
                
            }
        }
    }
    
    
}
