//
//  MetaImage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class MetaImage {
    
    let size: CGSize
    let url: NSURL
    
    init(size aSize: CGSize, url aURL: NSURL) {
        
        size = aSize
        url = aURL
    }
}