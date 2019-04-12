//
//  CollectionViewCell.swift
//  collView
//
//  Created by Jack Sp@rroW on 12/04/2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.bounds.size  = CGSize(width: 90, height: 90)
        image.clipsToBounds = true
        image.layer.cornerRadius = 15//image.frame.height / 2
        
        
    }
    
}
