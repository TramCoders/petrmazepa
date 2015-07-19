//
//  SimpleArticle.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import Foundation

class SimpleArticle {
    
    let title: String
    let smallImage: MetaImage
    
    init(title aTitle: String, smallImage aSmallImage: MetaImage) {
        
        smallImage = aSmallImage
        title = aTitle
    }
}