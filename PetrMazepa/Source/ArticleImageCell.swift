//
//  ArticleImageCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleImageCell: UICollectionViewCell, ArticleComponentCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func update(value: AnyObject?) {

        if let image = value as? UIImage {
            self.imageView.image = image
        } else {
            self.imageView.image = nil
        }
    }
}
