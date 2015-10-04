//
//  ArticleInfoCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleInfoCell: UICollectionViewCell, ArticleComponentCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
        
    func update(value: AnyObject?) {
        
        if let info = value as? ArticleInfo {

            self.dateLabel.text = info.dateString
            self.authorLabel.text = info.author

        } else {
            
            self.dateLabel.text = ""
            self.authorLabel.text = ""
        }
    }
}