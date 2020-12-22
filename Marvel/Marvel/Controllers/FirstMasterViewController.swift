//
//  MasterViewController.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 20/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import UIKit

class FirstMasterViewController: UITableViewController {

    var names = [String]()
    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We create an array with the main options to show in the first list
        names = ["Characters",
                 "Comics",
                 "Creators",
                 "Events",
                 "Series",
                 "Stories"]
        
        //We create an array with the images
        images = [Character.imageName,
                  Comic.imageName,
                  Creator.imageName,
                  Event.imageName,
                  Serie.imageName,
                  Story.imageName]
        
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let viewController = segue.destination as! DetailedMasterViewController
                viewController.category = Constants.TypeData.getValue(indexPath.row)
                let downloadManager = DownloadManagerImpl()
                let detailedMasterInteractor = DetailedMasterInteractorImpl(downloadManager: downloadManager, category: Constants.TypeData.getValue(indexPath.row))
                downloadManager.delegate = detailedMasterInteractor
                let detailedMasterPresenter = DetailedMasterPresenterImpl(interactor: detailedMasterInteractor, delegate: viewController)
                viewController.presenter = detailedMasterPresenter
                detailedMasterInteractor.delegate = detailedMasterPresenter
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.contentView.viewWithTag(1) as! UILabel).text = names[indexPath.row]
        (cell.contentView.viewWithTag(2) as! UIImageView).image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCategory", sender: self)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

