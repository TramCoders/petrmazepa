//
//  ArticleCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/8/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    
    override var highlighted: Bool {
        didSet {
            
            UIView.animateWithDuration(0.1) {
                self.dimmerView.alpha = (self.highlighted ? 1.0 : 0.0)
            }
        }
    }
    
    override func awakeFromNib() {

        super.awakeFromNib()
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
    
    func update(title title: String, image: UIImage?) {
        
        self.titleLabel.text = title
        self.imageView.image = image
        
        if image == nil {
        
            self.imageView.alpha = 0.0
            self.titleLabel.alpha = 1.0
            
        } else {
            
            self.imageView.alpha = 1.0
            self.titleLabel.alpha = 0.0
        }
        
    }
}