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
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass textfield string to destination view controller (FeedTableViewController) request property
    }
    
    @IBAction func button(_ sender: Any) {
        // trigger segue to FeedTableViewController
        
//        
//        requestArtistID(input: textField.text!) { (artistName, artistId, artistPhoto) in
//            print("name \(artistName), id \(artistId), photo \(artistPhoto)")
//            requestArtistNews(input: artistId)
//        }
    }
}

