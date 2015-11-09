//
//  Article.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import Foundation

class Article : NSObject {
    
    let id: String
    let title: String
    let author: String
    let thumbPath: String
    var favourite: Bool
    
    var thumbUrl: NSURL? {
        
        get {
            let urlString = "http://petrimazepa.com\(self.thumbPath)"
            return NSURL(string: urlString)
        }
    }
    
    init(id: String, title: String, author: String, thumbPath: String) {
        
        self.id = id
        self.title = title
        self.author = author
        self.thumbPath = thumbPath
        self.favourite = false
    }
}