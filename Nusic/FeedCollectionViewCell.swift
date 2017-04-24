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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var headline: UILabel!
   
    @IBOutlet weak var sourceTitle: UILabel!
    
    var article: Article! {
        didSet {
            configureCell()
        }
}

    func configureCell() {
        headline.text = article.articleTitle
        body.text = article.articleSummary
        sourceTitle.text = article.articleSourceTitle
        
        if let imageURL = article.articleImage {
            image.sd_setImage(with: URL(string: imageURL))
        }
}

}
