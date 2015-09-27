//
//  ImageCache.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class ImageCache {
    
    private let downloader: ImageDownloader
    private let storages: [ImageStorage]

    required init(storages: [ImageStorage], downloader: ImageDownloader) {
        
        self.storages = storages
        self.downloader = downloader
    }
    
    func requestImage(url url: NSURL, completion: (NSData?, NSError?) -> ()) -> Bool? {
        
        // search for the image in the storages
        if let imageData = self.loadImage(url: url) {

            completion(imageData, nil)
            return true
        }
        
        // download the image from the network
        self.downloader.downloadImage(url) { (data, error) -> () in

            if let notNilData = data {
                self.saveImage(url: url, data: notNilData)
            }
            
            completion(data, error)
        }
        
        return false
    }
    
    private func saveImage(url url: NSURL, data: NSData) {

        for storage in self.storages {
            storage.saveImage(url: url, data: data)
        }
    }
    
    private func loadImage(url url: NSURL) -> NSData? {

        for storage in self.storages {
            
            if let imageData = storage.loadImage(url: url) {
                return imageData
            }
        }
        
        return nil
    }
}
