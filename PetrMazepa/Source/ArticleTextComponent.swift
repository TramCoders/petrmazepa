//
//  ArticleTextComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleTextComponent: ArticleComponent {
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func value() -> AnyObject? {
        return self.text
    }
    
    func requiredHeight() -> CGFloat {

        let string = self.text as NSString
        let attributes = [ NSFontAttributeName: UIFont.systemFontOfSize(17) ]
        let width = UIScreen.mainScreen().bounds.width
        let size = string.boundingRectWithSize(CGSizeMake(width - 8, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return size.height
    }
    
    func cellIdentifier() -> String {
        return "TextCell"
    }
    
    func cellNib() -> UINib {
        return UINib(nibName: "ArticleTextCell", bundle: nil)
    }
}
