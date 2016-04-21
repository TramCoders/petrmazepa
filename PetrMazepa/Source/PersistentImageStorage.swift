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
        
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        let path = paths[0] as NSString
        return path.stringByAppendingPathComponent("\(NSBundle.mainBundle().bundleIdentifier!).images")
    }()
    
    private let manager = NSFileManager.defaultManager()
    
    init() {

        if !self.manager.fileExistsAtPath(self.cacheFolderPath) {
            do {
                try self.manager.createDirectoryAtPath(self.cacheFolderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // TODO: handle
            }
        }
    }
    
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
    
    func sizeInBytes() -> UInt64 {
        
        var size: UInt64 = 0
        let fileNames = self.fileNames()
        
        for fileName in fileNames {
            size += self.sizeOfFileInBytes(fileName)
        }
        
        return size
    }
    
    private func filePath(spec spec: ImageSpec) -> String {
        
        let key = self.key(spec: spec)
        let fileName = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        return self.cacheFolderPath.stringByAppendingString("/\(fileName)")
    }
    
    private func fileNames() -> [String] {
        
        let folderPath = self.cacheFolderPath
        
        do {
            return try self.manager.subpathsOfDirectoryAtPath(folderPath)
        } catch {
            return []
        }
    }
    
    private func sizeOfFileInBytes(fileName: String) -> UInt64 {
        
        let folderPath = self.cacheFolderPath
        let filePath = folderPath.stringByAppendingFormat("/%@", fileName)
        
        do {
            
            let attrs: NSDictionary = try self.manager.attributesOfItemAtPath(filePath)
            return attrs.fileSize()
            
        } catch {
            return 0
        }
    }
}
