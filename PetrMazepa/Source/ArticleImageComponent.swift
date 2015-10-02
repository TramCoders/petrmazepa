//
//  ArticleImageComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleImageComponent: ArticleComponent {

    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func value() -> AnyObject? {
        return self.image
    }
    
    func cellIdentifier() -> String {
        return "ImageCell"
    }
    
    func cellNib() -> UINib {
        return UINib(nibName: "ArticleImageCell", bundle: nil)
    }
    
    func requiredHeight() -> CGFloat {
        
        if let image = self.value() as? UIImage {

            let screenWidth = UIScreen.mainScreen().bounds.width
            let imageSize = image.size
            return imageSize.height * screenWidth / imageSize.width
            
        } else {
            return 200
        }
    }
}
