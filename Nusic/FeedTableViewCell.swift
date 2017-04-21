//
//  FeedTableViewCell.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-20.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import SDWebImage

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var cellHeadline: UILabel!
    @IBOutlet weak var cellBody: UILabel!
    @IBOutlet weak var cellSource: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    var article: Article! {
        didSet {
            configureCell()
        }
    }
    
    
    func configureCell() {
        cellHeadline.text = article.articleTitle
        cellBody.text = article.articleSummary
        cellSource.text = article.articleSourceTitle
        if let imageURL = article.articleImage {
            cellImage.sd_setImage(with: URL(string: imageURL))
        }
    }

    
}


