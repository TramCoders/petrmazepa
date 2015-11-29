//
//  ArticleTextComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleTextValue {

    let text: String?
    let delegate: ArticleTextCellDelegate
    
    init(text: String?, delegate: ArticleTextCellDelegate) {

        self.text = text
        self.delegate = delegate
    }
}

protocol ArticleTextComponentDelegate {
    func articleTextComponentDidDetermineHeight(sender component: ArticleTextComponent, height: CGFloat)
}

class ArticleTextComponent: ArticleComponent, ArticleTextCellDelegate {
    
    var text: String?
    private var height: CGFloat?
    var delegate: ArticleTextComponentDelegate?
    
    func value() -> AnyObject? {
        return ArticleTextValue(text: self.text, delegate: self)
    }
    
    func requiredHeight() -> CGFloat {

        if let notNilHeight = self.height {
            return notNilHeight
        } else {
            return 0
        }
    }
    
    func cellIdentifier() -> String {
        return "TextCell"
    }
    
    func cellNib() -> UINib {
        return UINib(nibName: "ArticleTextCell", bundle: nil)
    }
    
    func articleTextCellDidDetermineHeight(sender cell: ArticleTextCell, height: CGFloat) {

        self.height = height
        
        if let notNilDelegate = self.delegate {
            notNilDelegate.articleTextComponentDidDetermineHeight(sender: self, height: height)
        }
    }
}
