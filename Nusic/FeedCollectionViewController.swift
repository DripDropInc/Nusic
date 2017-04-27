//
//  FeedCollectionViewController.swift
//  Nusic
//
//  Created by Alex Rapier on 20/04/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class FeedCollectionViewController: UICollectionViewController {
    
    var artistID:Int?
    
    var request: String! {
        didSet {
            
            //progress HUD
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Fetching Artist News....."
            
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
    
    }
