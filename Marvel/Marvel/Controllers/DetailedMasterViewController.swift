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
		
		/*
		var prueba = StorageManager()
		prueba.saveName("")
		
		let characters = prueba.getCharacters()
        */
		
        let elementsDB = StorageManager.sharedInstance.getItems(self.category)
        
        self.items.addObjectsFromArray(elementsDB as [AnyObject])
        itemsTableView.reloadData()
		
		return
		
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name:"updateData", object: nil)
        
        let url = self.getUrl()
        let manager = DownloadManager.sharedInstance
        manager.downloadData(NSURL(fileURLWithPath: url))
        
        return
        
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
        itemsTableView.reloadData()
        
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

    
    
}
