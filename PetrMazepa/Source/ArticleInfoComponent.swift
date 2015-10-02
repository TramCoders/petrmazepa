//
//  ArticleInfoComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleInfo {
    
    let dateString: String
    let author: String
    
    init(dateString: String, author: String) {
        
        self.dateString = dateString
        self.author = author
    }
}

class ArticleInfoComponent: ArticleComponent {
    
    private let info: ArticleInfo
    
    init(info: ArticleInfo) {
        self.info = info
    }
    
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
        return 50
    }
}
