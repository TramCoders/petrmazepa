//
//  ImageCache.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ImageCache {
    
    var images: [NSURL: NSData]
    
    init() {
        self.images = [NSURL: NSData]()
    }
    
    init(images: [NSURL: NSData]) {
        self.images = images
    }
    
    func requestImage(url url: NSURL, completion: (NSData?, NSError?) -> ()) -> Bool? {
        
        if let imageData = self.images[url] {
            completion(imageData, nil)
            return true
        }
               
        return false
    }
}