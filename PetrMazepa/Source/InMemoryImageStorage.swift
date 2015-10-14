//
//  InMemoryImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class InMemoryImageStorage: ImageStorage {
    
    private var images = NSCache()
    
    func saveImage(url url: NSURL, data: NSData) {
        self.images.setObject(data, forKey: url)
    }
    
    func loadImage(url url: NSURL) -> NSData? {
        return self.images.objectForKey(url) as? NSData
    }
}
