//
//  InMemoryImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class InMemoryImageStorage: ImageStorage {
    
    typealias ImageObject = UIImage
    private var images = NSCache()
    
    func clear() {
        self.images.removeAllObjects()
    }
    
    func saveImage(withSpec spec: ImageSpec, image data: UIImage) {
        
        let key = self.key(forSpec: spec)
        self.images.setObject(data, forKey: key)
    }
    
    func loadImage(withSpec spec: ImageSpec) -> UIImage? {
        
        let key = self.key(forSpec: spec)
        return self.images.objectForKey(key) as? UIImage
    }
}
