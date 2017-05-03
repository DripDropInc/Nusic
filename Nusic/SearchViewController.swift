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
    
    var callbackBlock: ((Artist)->())?
    let collectionView = FeedCollectionViewController()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    let id = "FeedCollectionViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NUSIC"
        
        let recog : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(unwindFromSearch(sender:)))
        recog.numberOfTapsRequired = 1
        recog.numberOfTouchesRequired = 1
        recog.cancelsTouchesInView = false
        //recog.delegate = self as! UIGestureRecognizerDelegate
        self.view.window?.addGestureRecognizer(recog)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        goButton.isEnabled = true
        textField.text = ""
    }
    
        func unwindFromSearch(sender: UIStoryboardSegue) {
             textField.resignFirstResponder()
            performSegue(withIdentifier: "FeedCollectionViewController", sender: self)
            //collectionView.reloadData()
        }
    

    
    @IBAction func goTapped(_ sender: UIButton) {
        // disable the button
        textField.resignFirstResponder()
        
        // fetch the artistID
        
        guard let userInput = textField.text, userInput != "" else {
            return
        }
        sender.isEnabled = false

        fetchArtistID{ [unowned self]
            
            (artist: Artist?) in
            
            self.cleanupAfterArtistFetch()
            
            guard let artist = artist else {
                self.handleAlert()
                return
            }
            
            // kill
            guard let callbackBlock = self.callbackBlock else {
                return
            }
            
            callbackBlock(artist)
            
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
        let userInput = self.textField.text!
        NetworkManager.sharedInstance.requestArtist(with: userInput) {
            (artist: Artist?) in
            completionHandler(artist)
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
    
//    let tap = UITapGestureRecognizer(target: self, action: #selector(unwindFromSearch(sender:)))
//    view.tap = tap
//    


}
