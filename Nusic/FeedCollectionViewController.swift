//
//  FeedCollectionViewController.swift
//  Nusic
//
//  Created by Alex Rapier on 20/04/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Social

class FeedCollectionViewController: UICollectionViewController {
    
    
    
    
    //var artistID: Int! {
    //    didSet {
    //        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        loadingNotification.mode = MBProgressHUDMode.indeterminate
    //        loadingNotification.label.text = "Wait....."
    //
    //        requestArtistNews(input: artistID) {
    //            DispatchQueue.main.async {
    //                MBProgressHUD.hide(for: self.view, animated: true)
    //                self.collectionView?.reloadData()
    //
    //            }
    //        }
    //    }
    //}
    
    //    var artistID:Int?
    var articleURLToPost: String?
    
    //MARK: URL Alert
    func showUrlAlert()
    {
        let shareAlert = UIAlertController(title: "Error", message: "That URL does not exist", preferredStyle: .alert)
        let action = UIAlertAction (title: "Dismiss", style: .cancel, handler: nil)
        
        shareAlert.addAction(action)
        present(shareAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NUSIC"
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        layout.itemSize = itemSize
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if finalArray.count < 1 {
            // show popover
            performSegue(withIdentifier: "ViewController", sender: self)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let article = finalArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedCollectionViewCell
        
        cell.article = article
        let tap = UITapGestureRecognizer(target: self, action: #selector(segueToWebView))
        cell.tap = tap
        return cell
    }
    
    func segueToWebView() {
        performSegue(withIdentifier: "WebViewController", sender: self)
    }
    
    // MARK: Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // to make the artistID a field in the article
        
        if segue.identifier == "ViewController" {
            let popover = segue.destination as! ViewController
            popover.callbackBlock = fetchArticlesWith(artistID:)
            
        }
        
        guard let visibleCellIndexPath = (self.collectionView?.indexPathsForVisibleItems)?.first else {
            print(#line, "no visible cell")
            return
        }
        
        if segue.identifier == "BioViewController" {
            
            let articleClass = finalArray[visibleCellIndexPath.row]
            guard let bioViewController = segue.destination as? BioViewController, let artistID = articleClass.articleArtistID  else {
                return
            }
            
            requestArtistBio(input: artistID , complete: { (bioURL: String) in
                bioViewController.passedWikiURL = bioURL})
            
        }
        
        if segue.identifier == "WebViewController" {
            if let webCollectionViewController = segue.destination as? WebViewController {
                
                guard let articleURL = finalArray[visibleCellIndexPath.item].articleURL else {
                    print(#line, "no article url")
                    return
                }
                
                webCollectionViewController.passedURL = articleURL
            }
        }
        
    }
    
    internal func fetchArticlesWith(artistID: Int) {
        DispatchQueue.main.async {
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Wait....."
        }
        requestArtistNews(input: artistID) {
            DispatchQueue.main.async { [unowned self] in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.collectionView?.reloadData()
            }
        }
    }
    
    //MARK: Share Button
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        guard let visibleCellIndexPath = (self.collectionView?.indexPathsForVisibleItems)?.first else {
            print(#line, "no visible cell")
            return
        }
        
        let articleURL = finalArray[visibleCellIndexPath.item].articleURL
        
        //Alert
        let alert = UIAlertController(title: "Share", message: "Share Artist News", preferredStyle:.actionSheet)
        //Action 1
        let actionOne = UIAlertAction(title: "Share On Facebook", style: .default) { (action) in
            
            //Check if user is connected to facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                post?.setInitialText("\(String(describing: articleURL))")
                // post?.add(url: URL!(articleURL))
                
                self.present(post!, animated: true, completion: nil)
            }else {
                self.showShareAlert(service: "Facebook")
            }
        }
        //Action 2
        let actionTwo = UIAlertAction(title: "Share On Twitter", style: .default) { (action) in
            
            //Check if user is connected to facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                post?.setInitialText("\(String(describing: articleURL))")
                self.present(post!, animated: true, completion: nil)
            }else {
                self.showShareAlert(service: "Twitter")
            }
        }
        
        //Add action to action sheet
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        // Present alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showShareAlert(service:String)
    {
        let shareAlert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction (title: "Dismiss", style: .cancel, handler: nil)
        
        shareAlert.addAction(action)
        present(shareAlert, animated: true, completion: nil)
    }
    
    
}
