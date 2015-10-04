//
//  ArticleInfoComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleInfo {
    
    let date: NSDate?
    let author: String?
    
    init(date: NSDate?, author: String?) {
        
        self.date = date
        self.author = author
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
        return 40
    }
}
