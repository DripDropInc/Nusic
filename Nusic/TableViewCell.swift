//
//  TableViewCell.swift
//  Nusic
//
//  Created by Alex Rapier on 01/05/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var artist: Artist! {
        didSet {
            configureCell()
        }
    }
    
    func configureCell() {
        
        artistName.text = artist.artistName
        
        if let imageURL = artist.artistImage {
            artistImage.sd_setImage(with: URL(string: imageURL))
        }
    }


}
