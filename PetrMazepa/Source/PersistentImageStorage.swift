//
//  PersistentImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class PersistentImageStorage: ImageStorage {
    
    typealias ImageObject = NSData
    
    private let cacheFolderPath: String = {
        
        var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }()
    
    func saveImage(spec spec: ImageSpec, image data: NSData) {
        data.writeToFile(self.filePath(spec: spec), atomically: false)
    }
    
    func deleteImage(spec spec: ImageSpec) {
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.removeItemAtPath(self.filePath(spec: spec))
        } catch {
            // TODO: handle
        }
    }
    
    func loadImage(spec spec: ImageSpec) -> NSData? {
        
        let filePath = self.filePath(spec: spec)
        
        if let imageData = NSData(contentsOfFile: filePath) {
            return imageData
        }
        
        return nil
    }
    
    private func filePath(spec spec: ImageSpec) -> String {
        
        let key = self.key(spec: spec)
        let fileName = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        return self.cacheFolderPath.stringByAppendingString(fileName!)
    }
}
