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
    
    func clear() {      // not the best implementation
        
        let fileManager = NSFileManager.defaultManager()
        let imageNames: [String]
        
        do {
            imageNames = try fileManager.contentsOfDirectoryAtPath(self.cacheFolderPath)
        } catch {
            imageNames = []
        }
        
        for imageName in imageNames {
            do {
                
                let imagePath = "\(self.cacheFolderPath)/\(imageName)"
                try fileManager.removeItemAtPath(imagePath)
                
            } catch {
                // do nothing
            }
        }
    }
    
    func saveImage(spec spec: ImageSpec, image data: NSData) {
        data.writeToFile(self.filePath(spec: spec), atomically: false)
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
        let fileName = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        return self.cacheFolderPath.stringByAppendingString("/\(fileName)")
    }
}
