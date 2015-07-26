//
//  SimpleArticle.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import Foundation

class SimpleArticle : NSObject {
    
    let id: String
    let title: String
    let smallImage: MetaImage
    let articleUrl: NSURL
    
    init(id: String, title: String, smallImage: MetaImage, articleUrl: NSURL) {
        
        self.id = id
        self.title = title
        self.smallImage = smallImage
        self.articleUrl = articleUrl
    }
    
}