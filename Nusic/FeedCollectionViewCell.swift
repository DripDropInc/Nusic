//
//  FeedCollectionViewCell.swift
//  Nusic
//
//  Created by Alex Rapier on 20/04/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import SDWebImage

protocol FeedCellDelegate {
    func showDetails(cell: FeedCollectionViewCell)
}

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var headline: UILabel!
   
    @IBOutlet weak var sourceTitle: UILabel!
    var delegate : FeedCellDelegate?
    
    var imageTapRecognizer : UITapGestureRecognizer!
    
    var article: Article! {
        didSet {
            configureCell()
        }
    }
    
    func imageTapped(_ sender: UIImage) {
        // Call delegate function (back to collection view) and push segue
        delegate?.showDetails(cell: self)
    }

    func configureCell() {
        if (imageTapRecognizer == nil) {
            imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageTapRecognizer.numberOfTapsRequired = 1
        }
        image.addGestureRecognizer(imageTapRecognizer)
        
        headline.text = article.articleTitle
        body.text = article.articleSummary
        sourceTitle.text = article.articleSourceTitle
        
        if let imageURL = article.articleImage {
            image.sd_setImage(with: URL(string: imageURL))
        }
}

}
