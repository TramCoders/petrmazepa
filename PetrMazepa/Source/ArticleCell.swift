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
        self.layer.masksToBounds = true
    }
    
    func update(title title: String, image: UIImage?, roundedCorner: RoundedCorner) {
        
        self.titleLabel.text = title
        self.imageView.image = image
        
        self.updateImageVisibility(image != nil)
        self.updateTitleVisibility(image == nil)
        self.updateRoundedCorner(roundedCorner)
    }
    
    private func updateImageVisibility(visible: Bool) {
        
        if visible {
            self.imageView.alpha = 1.0
        } else {
            self.imageView.alpha = 0.0
        }
    }
    
    private func updateTitleVisibility(visible: Bool) {
        
        if visible {
            self.titleLabel.alpha = 1.0
        } else {
            self.titleLabel.alpha = 0.0
        }
    }
    
    private func updateRoundedCorner(roundedCorner: RoundedCorner) {
        
        guard let corners = self.convertRoundedCorners(roundedCorner) else {
        
            self.layer.mask = nil
            return
        }
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(4.0, 4.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
    
    private func convertRoundedCorners(roundedCorner: RoundedCorner) -> UIRectCorner? {
        
        switch roundedCorner {
            
            case .TopLeft: return .TopLeft
            case .TopRight: return .TopRight
            default: return nil
        }
    }
}
