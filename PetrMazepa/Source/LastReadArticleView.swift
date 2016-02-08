//
//  LastReadArticleView.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 20/01/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

class LastReadArticleView: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var highlighted: Bool {
        didSet {
            UIView.animateWithDuration(0.1) {
                self.backgroundColor = self.highlighted ? UIColor.blackColor() : UIColor.clearColor()
            }
        }
    }
    
    var model: SimpleArticleCellModel? {
        didSet {
            
            guard let notNilModel = self.model else {
                return
            }
            
            self.titleLabel.text = notNilModel.title
            
            notNilModel.requestImage(size: self.imageView.bounds.size) { image, _, _ in
                self.imageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2.0
        self.imageView.layer.masksToBounds = true
    }
}
