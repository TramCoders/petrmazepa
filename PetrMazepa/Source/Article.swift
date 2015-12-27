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
    let thumbPath: String
    var favourite: Bool
    var topOffset: Float
    
    var thumbUrl: NSURL? {
        
        get {
            let urlString = "http://petrimazepa.com\(self.thumbPath)"
            return NSURL(string: urlString)
        }
    }
    
    convenience init(id: String, title: String, thumbPath: String) {
        self.init(id: id, title: title, thumbPath: thumbPath, favourite: false, topOffset: 0.0)
    }
    
    init(id: String, title: String, thumbPath: String, favourite: Bool, topOffset: Float) {
        
        self.id = id
        self.title = title
        self.thumbPath = thumbPath
        self.favourite = favourite
        self.topOffset = topOffset
    }
}
