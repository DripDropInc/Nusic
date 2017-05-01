//
//  ViewController.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-20.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import QuartzCore


class ViewController: UIViewController {
    
    var callbackBlock: ((Int)->())?
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    let id = "FeedCollectionViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NUSIC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        goButton.isEnabled = true
        textField.text = ""
    }
    

    
    @IBAction func goTapped(_ sender: UIButton) {
        // disable the button
        textField.resignFirstResponder()
        
        // fetch the artistID
        
        guard let userInput = textField.text, userInput != "" else {
            return
        }
        sender.isEnabled = false
        
//        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Wait....."
        
        fetchArtistID{ [unowned self]
            (artistID: Int?) in
            
            self.cleanupAfterArtistIDFetch()
            
            guard let artistID = artistID else {
                self.handleAlert()
                return
            }
            
            // kill
            guard let callbackBlock = self.callbackBlock else {
                return
            }
            
            callbackBlock(artistID)
//            self.pushToCollectionView(with: artistID)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    private func cleanupAfterArtistIDFetch() {
        DispatchQueue.main.async { [unowned self] in
            self.goButton.isEnabled = true
            MBProgressHUD.hide(for: self.view, animated: true)
            self.textField.text = ""
        }
    }
    
    private func fetchArtistID(completionHandler: @escaping (Int?)->()) {
        requestArtistID(Input: self.textField.text!) {
            (artistName, artistID, artistPhoto) in
            completionHandler(artistID)
        }
    }
    
    // kill
//    private func pushToCollectionView(with artistID: Int) {
//        DispatchQueue.main.async { [unowned self] in
//            // create a FeedCollectionViewController
//            // pass it the artistID
//            let feedVC = self.storyboard?.instantiateViewController(withIdentifier: self.id) as! FeedCollectionViewController
//            feedVC.artistID = artistID
//            self.navigationController?.pushViewController(feedVC, animated: true)
//        }
//    }
    
    private func handleAlert() {
        // in background Q
        let userInput = textField.text
        let message = "Artist \(userInput ?? "nil") could not be found. Try again."
        let alertView = UIAlertController(title: "Error", message: message , preferredStyle: .alert)
        let action = UIAlertAction(title: "Unfound Artist", style: .cancel, handler: nil)
        alertView.addAction(action)
        present(alertView, animated: true) {
            self.textField.text = ""
            self.textField.becomeFirstResponder()
        }
    }
    
}
