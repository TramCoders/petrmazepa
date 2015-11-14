//
//  SearchedArticleCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/5/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchedArticleCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: SearchedArticleCellModel! {
        didSet {
            
            self.titleLabel.text = self.model.title
            self.thumbImageView.image = nil
            
            self.requestImage()
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        // accessory type
        self.accessoryType = .DisclosureIndicator
        
        // corner radius
        self.thumbImageView.layer.cornerRadius = self.thumbImageView.frame.width / 2
        self.thumbImageView.layer.masksToBounds = true
    }

    private func requestImage() {
        
        self.model.requestImage(size: self.bounds.size) { image, _, fromCache in
            self.updateImage(image, animated: !fromCache)
        }
    }
    
    private func updateImage(image: UIImage?, animated: Bool) {
    
        if animated {
            
            UIView.transitionWithView(self.thumbImageView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.updateImage(image)
            }, completion: nil)
            
        } else {
            self.updateImage(image)
        }
    }
    
    private func updateImage(image: UIImage?) {
        self.thumbImageView.image = image
    }
}
