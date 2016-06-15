//
//  ImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ImageStorage {
    
    associatedtype ImageObject
    func saveImage(withSpec spec: ImageSpec, image: ImageObject)
    func loadImage(withSpec spec: ImageSpec) -> ImageObject?
    func clear()
}

extension ImageStorage {

    func key(forSpec spec: ImageSpec) -> String {
        
        if let size = spec.size {
            return spec.url.URLByAppendingPathComponent("\(size.width)").URLByAppendingPathComponent("\(size.height)").absoluteString
        } else {
            return "\(spec.url.absoluteString)"
        }
    }
}
