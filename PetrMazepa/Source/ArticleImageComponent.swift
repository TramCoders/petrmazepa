//
//  ArticleImageComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleImageComponent: ArticleComponent {

    var image: UIImage?
    
    func value() -> AnyObject? {
        return self.image
    }
    
    func cellIdentifier() -> String {
        return 
    }
    
    func cellNib() -> UINib {
        return UINib(nibName: "ArticleImageCell", bundle: nil)
    }
    
    func requiredHeight() -> CGFloat {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        if let image = self.value() as? UIImage {

            let imageSize = image.size
            return imageSize.height * screenWidth / imageSize.width
            
        } else {
            return 0.0
        }
    }
}
