//
//  ImageCache.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ImageCache {
    
    var images: [NSURL: NSData]
    
    private var session: NSURLSession {
        get {
            return NSURLSession.sharedSession()
        }
    }
    
    init() {
        self.images = [NSURL: NSData]()
    }
    
    init(images: [NSURL: NSData]) {
        self.images = images
    }
    
    func requestImage(url url: NSURL, completion: (NSData?, NSError?) -> ()) -> Bool? {
        
        if let imageData = self.images[url] {

            completion(imageData, nil)
            return true
        }
        
        let request = NSURLRequest(URL: url)
        
        self.session.downloadTaskWithRequest(request) { (fileUrl: NSURL?, _, error: NSError?) -> Void in
            
            if error != nil {
                
                completion(nil, error)
                return
            }
            
            guard let notNilFileUrl = fileUrl else {
                
                completion(nil, nil)
                return
            }
            
            if let imageData = NSData(contentsOfURL: notNilFileUrl) {

                self.images[url] = imageData
                completion(imageData, nil)

            } else {
                completion(nil, nil)
            }

        }.resume()
        
        return false
    }
}
