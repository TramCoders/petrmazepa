//
//  ArticleCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/8/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func update(image: UIImage?) {
        
        if image == nil {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        
        self.imageView.image = image
    }
}