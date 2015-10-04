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
    let dateString: String
    
    init(id: String, title: String, author: String, thumbPath: String, htmlText: String, dateString: String) {
        
        self.htmlText = htmlText
        self.dateString = dateString
        super.init(id: id, title: title, author: author, thumbPath: thumbPath)
    }
}
