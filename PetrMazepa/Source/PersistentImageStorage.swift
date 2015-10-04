//
//  PersistentImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class PersistentImageStorage: ImageStorage {
    
    private let cacheFolderPath: String = {
        
        var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }()
    
    func saveImage(url url: NSURL, data: NSData) {
        data.writeToFile(self.filePath(imageUrl: url), atomically: false)
    }
    
    func loadImage(url url: NSURL) -> NSData? {
        
        let filePath = self.filePath(imageUrl: url)
        
        if let imageData = NSData(contentsOfFile: filePath) {
            return imageData
        }
        
        return nil
    }
    
    private func filePath(imageUrl url: NSURL) -> String {
        
        let fileName = url.absoluteString
        return self.cacheFolderPath.stringByAppendingString(fileName)
    }
}
