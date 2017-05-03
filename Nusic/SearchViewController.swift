//
//  ViewController.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-20.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController {
    
    
    
    // Properties
    var callbackBlock: ((Artist)->())?
    let collectionView = FeedCollectionViewController()
    let id = "FeedCollectionViewController"

    
    //Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets Nav Title.
        self.navigationItem.title = "NUSIC"
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        textField.becomeFirstResponder()
        //Brings up textField
        goButton.isEnabled = true
        textField.text = ""
        //Sets default text to nil
    }
    
    
    //Function for when you click off the Search View
        func unwindFromSearch(sender: UIStoryboardSegue) {
             textField.resignFirstResponder()
            performSegue(withIdentifier: id, sender: self)
            //Removes Keyboard and then performs segue with FeedCollectionViewController
    
    }
    
    @IBAction func goTapped(_ sender: UIButton) {
        // disable the button
        textField.resignFirstResponder()
        
        //Sets userinput to the user's input from the textField, if its empty will just return out of the function.
        guard let userInput = textField.text, userInput != "" else {
            return
        }
        
        sender.isEnabled = false

        
        //Fetches ArtistID
        fetchArtistID{ [unowned self] //Makes it a weak function.
            
            (artist: Artist?) in
            
            self.cleanupAfterArtistFetch()
            //Fires loading animation.
            
            guard let artist = artist else {
                self.handleAlert()
                return
            }
            
            // kill
            guard let callbackBlock = self.callbackBlock else {
                return
            }
            
            callbackBlock(artist)
            //Call back block is going to fetch the artistsNews 
            
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    private func cleanupAfterArtistFetch() {
        DispatchQueue.main.async { [unowned self] in
            self.goButton.isEnabled = true
            MBProgressHUD.hide(for: self.view, animated: true)
            self.textField.text = ""
        }
    }
    
    private func fetchArtistID(completionHandler: @escaping (Artist?)->()) {
        
        //Function calls the RequestArtist with with userinput caller.
        
        let userInput = self.textField.text!
        NetworkManager.sharedInstance.requestArtist(with: userInput) {
            (artist: Artist?) in
            completionHandler(artist)
            
            //Returns artist Artist with Completion handler. Once we got the userinput, we stick that into the request artist function, completion handler is going to return an artist object. 
        }
    }
    
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
