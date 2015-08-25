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
    
    init(id: String, title: String) {
        
        self.id = id
        self.title = title
    }
    
}