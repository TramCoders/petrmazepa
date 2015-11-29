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
            self.updateRoundedCorner()
            self.updateVisibilities(imageVisible: false, animated: false)
            
            self.requestImage()
        }
    }
    
    override func awakeFromNib() {

        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
    
    private func updateTitle() {
        self.titleLabel.text = self.model.title
    }
    
    private func updateRoundedCorner() {
        self.updateRoundedCorner(self.model.roundedCorner)
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
