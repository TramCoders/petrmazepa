//
//  ArticleTextCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleTextCell: UICollectionViewCell, ArticleComponentCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    func update(value: AnyObject?) {
        
        if let text = value as? String {
            self.textLabel.text = text
        } else {
            self.textLabel.text = ""
        }
    }
    
}
