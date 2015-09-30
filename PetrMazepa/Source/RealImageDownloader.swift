//
//  RealImageDownloader.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class RealImageDownloader: ImageDownloader {
    
    private let session = NSURLSession.sharedSession()
    
    func downloadImage(url: NSURL, completion: (NSData?, NSError?) -> ()) {
        
        let request = NSURLRequest(URL: url)
        self.session.downloadTaskWithRequest(request) { (fileUrl: NSURL?, _, error: NSError?) -> () in
            
            guard let notNilFileUrl = fileUrl else {
                
                completion(nil, error)
                return
            }
            
            if let imageData = NSData(contentsOfURL: notNilFileUrl) {
                completion(imageData, error)
            } else {
                completion(nil, error)
            }
            
        }.resume()
    }
}