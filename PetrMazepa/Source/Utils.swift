//
//  Utils.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 6/21/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation


extension NSURL {
    
    static func temporaryURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
    }
    
    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
}

extension CollectionType where Generator.Element: Hashable {
    
    func unique() -> [Generator.Element] {
        var uniqueElements: Set<Generator.Element> = []
        return filter{
            if uniqueElements.contains($0) {
                return false
            } else {
                uniqueElements.insert($0)
                return true
            }
        }
    }
}
