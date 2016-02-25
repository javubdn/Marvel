//
//  MasterViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 20/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import UIKit
import CryptoSwift

class FirstMasterViewController: UITableViewController {

    var names = [AnyObject]()
    var images = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We create an array with the main options to show in the first list
        names.insert("Characters", atIndex: 0)
        names.insert("Comics", atIndex: 1)
        names.insert("Creators", atIndex: 2)
        names.insert("Events", atIndex: 3)
        names.insert("Series", atIndex: 4)
        names.insert("Stories", atIndex: 5)
        
        //We create an array with the images
        images.insert("list1", atIndex: 0)
        images.insert("list2", atIndex: 1)
        images.insert("list3", atIndex: 2)
        images.insert("list4", atIndex: 3)
        images.insert("list5", atIndex: 4)
        images.insert("list6", atIndex: 5)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCategory" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let viewController:DetailedMasterViewController = segue.destinationViewController as! DetailedMasterViewController
                viewController.category = Constants.TypeData.getValue(indexPath.row)
                
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let name = names[indexPath.row] as! String
        let image = images[indexPath.row] as! String
        
        (cell.contentView.viewWithTag(1) as! UILabel).text = name
        (cell.contentView.viewWithTag(2) as! UIImageView).image = UIImage(named: image)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showCategory", sender: self)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }


}

