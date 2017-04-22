//
//  ViewController.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-20.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "NUSIC"
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass textfield string to destination view controller (FeedTableViewController) request property
        if segue.identifier == "FeedCollectionViewController" {
            if let feedCollectionViewController = segue.destination as? FeedCollectionViewController {
                feedCollectionViewController.request = textField.text
            }
        }
        
    }

}

