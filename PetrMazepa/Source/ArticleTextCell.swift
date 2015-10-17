//
//  ArticleTextCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleTextCell: UICollectionViewCell, ArticleComponentCell {
    
    @IBOutlet weak var textView: UITextView!
    
    func update(value: AnyObject?) {
        
        if let text = value as? String {
            self.textView.text = text
        } else {
            self.textView.text = ""
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = UIEdgeInsetsZero
    }
}
