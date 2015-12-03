//
//  ArticleImageCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleImageCell: UICollectionViewCell {
    
    var model: ArticleImageCellViewModel! {
        didSet {
            self.model.requestImage(size: CGSizeMake(self.bounds.width, 240.0)) { image, _, _ in
                
                self.imageView.image = image
                // TODO: delegation
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
}
