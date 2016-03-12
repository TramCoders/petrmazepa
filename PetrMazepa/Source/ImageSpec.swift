//
//  ImageSpec.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 16/02/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

struct ImageSpec {
    
    let url: NSURL
    let size: CGSize?
    
    init(url: NSURL) {
        
        self.url = url
        self.size = nil
    }
    
    init(url: NSURL, size: CGSize) {
        
        self.url = url
        self.size = size
    }
}
