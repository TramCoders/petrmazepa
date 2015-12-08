//
//  ArticleImageCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
}
