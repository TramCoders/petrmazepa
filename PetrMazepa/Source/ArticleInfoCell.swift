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
    
    private let dateFormatter: NSDateFormatter
    
    required init?(coder aDecoder: NSCoder) {
        
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "dd.MM.yyyy"    // TODO: check
        
        super.init(coder: aDecoder)
    }
    
    func update(value: AnyObject?) {
        
        if let info = value as? ArticleInfo {

            if let notNilDate = info.date {
                self.dateLabel.text = self.dateFormatter.stringFromDate(notNilDate)
            } else {
                self.dateLabel.text = ""
            }
            
            self.authorLabel.text = info.author

        } else {
            
            self.dateLabel.text = ""
            self.authorLabel.text = ""
        }
    }
}