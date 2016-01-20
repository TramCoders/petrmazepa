//
//  LastReadArticleView.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 20/01/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

class LastReadArticleView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2.0
        self.imageView.layer.masksToBounds = true
    }
}
