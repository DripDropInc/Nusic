//
//  TableViewController.swift
//  Nusic
//
//  Created by Alex Rapier on 01/05/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController {

    var followed: [Artist]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        followed = NetworkManager.sharedInstance.followedArists()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followed?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let artist = NetworkManager.sharedInstance.artists[indexPath.row]
            artist.follow = false
            followed?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentArtist = followed?[indexPath.row]

        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.artist = currentArtist
        return cell
    }

}
