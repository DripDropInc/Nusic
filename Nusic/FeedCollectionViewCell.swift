//
//  FeedCollectionViewCell.swift
//  Nusic
//
//  Created by Alex Rapier on 20/04/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import SDWebImage

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followTapped(_ sender: UIButton) {
        article.artist?.follow = !(article.artist?.follow)!
        configureButton()
    }
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var headline: UILabel!
    
    @IBOutlet weak var sourceTitle: UILabel!
    
    var tap : UITapGestureRecognizer! {
        didSet {
            if image.gestureRecognizers == nil || image.gestureRecognizers?.count == 0 {
                image.addGestureRecognizer(tap)
            }
        }
    }
    
    var article: Article! {
        didSet {
            configureCell()
        }
    }
    
    private func configureButton() {
        let title = (article.artist?.follow)! ? "UnFollow" : "Follow"
        followButton.setTitle(title, for: .normal)
    }
    
    func configureCell() {
        configureButton()
        headline.text = article.articleTitle
        body.text = article.articleSummary
        sourceTitle.text = article.articleSourceTitle
        
        if let imageURL = article.articleImage {
            image.sd_setImage(with: URL(string: imageURL))
        }
    }
    
}
