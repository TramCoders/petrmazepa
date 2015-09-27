//
//  ImageCache.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class ImageCache {
    
    private let session = NSURLSession.sharedSession()
    private let storages: [ImageStorage]

    init() {
        self.storages = [ InMemoryImageStorage(), PersistentImageStorage()]
    }
    
    init(storages: [ImageStorage]) {
        self.storages = storages
    }
    
    func requestImage(url url: NSURL, completion: (NSData?, NSError?) -> ()) -> Bool? {
        
        if let imageData = self.loadImage(url: url) {

            completion(imageData, nil)
            return true
        }
        
        let request = NSURLRequest(URL: url)
        self.session.downloadTaskWithRequest(request) { (fileUrl: NSURL?, _, error: NSError?) -> () in
            
            if error != nil {
                
                completion(nil, error)
                return
            }
            
            guard let notNilFileUrl = fileUrl else {
                
                completion(nil, nil)
                return
            }
            
            if let imageData = NSData(contentsOfURL: notNilFileUrl) {

                self.saveImage(url: url, data: imageData)
                completion(imageData, nil)

            } else {
                completion(nil, nil)
            }

        }.resume()
        
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
