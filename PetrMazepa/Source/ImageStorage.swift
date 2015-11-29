//
//  ImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ImageStorage {
    
    typealias ImageObject
    func saveImage(spec spec: ImageSpec, image: ImageObject)
    func deleteImage(spec spec: ImageSpec)
    func loadImage(spec spec: ImageSpec) -> ImageObject?
}

extension ImageStorage {

    func key(spec spec: ImageSpec) -> String {
        
        if let size = spec.size {
            return spec.url.URLByAppendingPathComponent("\(size.width)").URLByAppendingPathComponent("\(size.height)").absoluteString
        } else {
            return "\(spec.url.absoluteString)"
        }
    }
}
