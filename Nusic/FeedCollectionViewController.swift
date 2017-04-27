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
    
    var artistID:Int?
    var articleURLToPost: String?
    
    var request: String! {
        didSet {
            
            //progress HUD
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Fetching Artist News....."
  
            //MARK: Request Artis ID, Request News
            
            requestArtistID(Input: request) { (artistName, artistId, artistPhoto) in
                
                print("name \(artistName), id \(artistId), photo \(artistPhoto)")
                
                
                self.artistID = artistId
                
                
                requestArtistNews(input: artistId) {
                    
                    DispatchQueue.main.async {
                        
                        //dismiss HUD and reload
                        MBProgressHUD.hide(for: self.view, animated: true)
                        //                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                        self.collectionView?.reloadData()
                        
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NUSIC"
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        layout.itemSize = itemSize
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
