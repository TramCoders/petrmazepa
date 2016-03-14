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
    
    var model: ArticleCellModel! {
        didSet {
            
            self.updateTitle()
            self.updateVisibilities(imageVisible: false, animated: false)
            
            self.requestImage()
        }
    }
    
    private let activeColor = UIColor(red: 0.933, green: 0.427, blue: 0.439, alpha: 0.9)
    private let unactiveColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
    
    override func awakeFromNib() {

        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
    
    private func updateTitle() {
        self.titleLabel.text = self.model.title
    }
    
    private func requestImage() {
        
        self.model.requestImage(size: self.bounds.size) { image, _, fromCache in
            
            self.imageView.image = image
            let visible = (image != nil)
            self.updateVisibilities(imageVisible: visible, animated: (!fromCache && visible))
        }
    }
    
    private func updateVisibilities(imageVisible visible: Bool, animated: Bool) {
    
        let duration: NSTimeInterval = animated ? 0.4 : 0.0
        
        UIView.animateWithDuration(duration) {
            self.updateVisibilities(imageVisible: visible == true)
        }
    }
    
    private func updateVisibilities(imageVisible visible: Bool) {

        self.imageView.alpha = visible ? 1.0 : 0.0
        self.titleLabel.alpha = visible ? 0.0 : 1.0
    }
}
