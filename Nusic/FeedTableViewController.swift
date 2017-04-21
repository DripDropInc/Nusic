//
//  FeedTableViewController.swift
//  
//
//  Created by Alex Rapier on 20/04/2017.
//
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var request: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let request = self.request {
            requestArtistID(input: request) { (artistName, artistId, artistPhoto) in
                print("name \(artistName), id \(artistId), photo \(artistPhoto)")
                requestArtistNews(input: artistId) {
                    self.tableView.reloadData()
                }
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articlesArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = articlesArray[indexPath.row] as! Article
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        cell.article = article

        return cell
    }
}
