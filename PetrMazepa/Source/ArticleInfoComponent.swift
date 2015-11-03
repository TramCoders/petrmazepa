//
//  ArticleInfoComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleInfo {
    
    let dateString: String?
    let author: String?
    
    init(dateString: String?, author: String?) {
        
        self.dateString = dateString
        self.author = author
    }
    
    func isEmpty() -> Bool {
        return (self.author == nil || self.author == "") && (self.dateString == nil || self.dateString == "")
    }
}

class ArticleInfoComponent: ArticleComponent {
    
    var info: ArticleInfo?
    
    func value() -> AnyObject? {
        return self.info
    }
    
    func cellIdentifier() -> String {
        return "InfoCell"
    }
    
    func cellNib() -> UINib {
        return UINib(nibName: "ArticleInfoCell", bundle: nil)
    }
    
    func requiredHeight() -> CGFloat {
        
        if (self.info == nil) || (self.info?.isEmpty() == true) {
            return 0.0
        } else {
            return 40.0
        }
    }
}
