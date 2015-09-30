//
//  ImageStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ImageStorage {
    
    func saveImage(url url: NSURL, data: NSData)
    func saveImages(images: [NSURL: NSData])
    func loadImage(url url: NSURL) -> NSData?
}

extension ImageStorage {
    
    func saveImages(images: [NSURL: NSData]) {
        
        for (url, data) in images {
            self.saveImage(url: url, data: data)
        }
    }
}
