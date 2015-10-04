//
//  ArticleDetails.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class ArticleDetails: Article {
    
    let htmlText: String
    let date: NSDate
    
    init(id: String, title: String, author: String, thumbPath: String, htmlText: String, date: NSDate) {
        
        self.htmlText = htmlText
        self.date = date
        super.init(id: id, title: title, author: author, thumbPath: thumbPath)
    }
}
