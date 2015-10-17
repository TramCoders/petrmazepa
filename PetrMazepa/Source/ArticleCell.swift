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
    @IBOutlet weak var dimmerView: UIView!
    
    override var highlighted: Bool {
        didSet {
            
            UIView.animateWithDuration(0.1) {
                self.dimmerView.alpha = (self.highlighted ? 1.0 : 0.0)
            }
        }
    }
    
    func update(image: UIImage?) {
        
        if image == nil {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        
        self.imageView.image = image
    }
    
    
}