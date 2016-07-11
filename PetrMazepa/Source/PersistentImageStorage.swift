//
//  PersistentImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class PersistentImageStorage {

    private let tracker: ITracker
    
    private let cacheFolderPath: String = {

        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        let path = paths[0] as NSString
        return path.stringByAppendingPathComponent("\(NSBundle.mainBundle().bundleIdentifier!).images")
    }()

    private let fileManager: NSFileManager

    init(tracker: ITracker) {

        self.tracker = tracker
        
        fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(cacheFolderPath) {
            do {
                try fileManager.createDirectoryAtPath(cacheFolderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                let description = (error as NSError).extensiveLocalizedDescription ?? "Unable to create folder at path \(cacheFolderPath)"
                tracker.trackException(withDescription: description)
                fatalError(description)
            }
        }
    }
}

//MARK: ImageStorage
extension PersistentImageStorage: ImageStorage {

    typealias ImageObject = NSData

    func clear() {

        guard let imageNames = try? fileManager.contentsOfDirectoryAtPath(cacheFolderPath) else {
            return
        }
        imageNames.forEach { imageName in
            do {
                try fileManager.removeItemAtPath("\(cacheFolderPath)/\(imageName)")
            } catch {
                let description = (error as NSError).extensiveLocalizedDescription ?? "Unable to remove from cache folder file with name \(imageName)"
                Tracker.trackException(withDescription: description)
            }
        }
    }

    func saveImage(withSpec spec: ImageSpec, image data: NSData) {
        data.writeToFile(self.filePath(forSpec: spec), atomically: false)
    }

    func loadImage(withSpec spec: ImageSpec) -> NSData? {

        let filePath = self.filePath(forSpec: spec)
        return NSData(contentsOfFile: filePath) ?? nil
    }
}

//MARK: File Attribute – Path
private extension PersistentImageStorage {

    func filePath(forSpec spec: ImageSpec) -> String {

        let key = self.key(forSpec: spec)
        let fileName = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        return cacheFolderPath.stringByAppendingString("/\(fileName)")
    }

    func fileNames() -> [String]? {

        guard let paths = try? fileManager.subpathsOfDirectoryAtPath(cacheFolderPath) else {
            return nil
        }
        return paths
    }
}

//MARK: File Attribute – Size
extension PersistentImageStorage {

    func sizeInBytes() -> UInt64 {

        guard let fileNames = fileNames() else {
            return 0
        }

        return fileNames.reduce(0, combine: { (value, fileName) -> UInt64 in
            return value + self.sizeOfFileInBytes(fileName)
        })
    }
    
    private func sizeOfFileInBytes(fileName: String) -> UInt64 {
        
        let filePath = cacheFolderPath.stringByAppendingFormat("/%@", fileName)
        guard let attrs = try? fileManager.attributesOfItemAtPath(filePath) as NSDictionary else {
            return 0
        }
        return attrs.fileSize()
    }
}
