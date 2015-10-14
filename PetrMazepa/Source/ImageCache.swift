//
//  ImageCache.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

struct ImageSpec {
    
    let url: NSURL
    let size: CGSize?
    
    init(url: NSURL) {
        
        self.url = url
        self.size = nil
    }
    
    init(url: NSURL, size: CGSize) {
        
        self.url = url
        self.size = size
    }
}

class ImageCache {
    
    typealias ImageHandler = (image: UIImage?, error: NSError?, fromCache: Bool) -> ()
    
    private let downloader: ImageDownloader
    private let inMemoryImageStorage: InMemoryImageStorage
    private let persistentImageStorage: PersistentImageStorage

    required init(inMemoryImageStorage: InMemoryImageStorage, persistentImageStorage: PersistentImageStorage, downloader: ImageDownloader) {
        
        self.inMemoryImageStorage = inMemoryImageStorage
        self.persistentImageStorage = persistentImageStorage
        self.downloader = downloader
    }
    
    func requestImage(spec spec: ImageSpec, completion: ImageHandler) {
        
        // search for the image in the in-memory storage
        if let image = self.inMemoryImageStorage.loadImage(spec: spec) {
            
            completion(image: image, error: nil, fromCache: true)
            return
        }
        
        // search for the image in the persistent
        let urlSpec = ImageSpec(url: spec.url)
        
        if let imageData = self.persistentImageStorage.loadImage(spec: urlSpec) {
            
            let image = self.saveImage(spec: spec, data: imageData)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                completion(image: image, error: nil, fromCache: false)
            }
            
            return
        }
        
        // download the image from the network
        self.downloader.downloadImage(spec.url) { (data, error) -> () in

            let image: UIImage?
            
            if let notNilData = data {
                image = self.saveImage(spec: spec, data: notNilData)
                
            } else {
                image = nil
            }
            
            completion(image: image, error: error, fromCache: false)
        }
    }
    
    private func saveImage(spec spec: ImageSpec, data: NSData) -> UIImage? {

        guard let image = UIImage(data: data) else {
            return nil
        }
        
        let resizedImage: UIImage!
        
        if let notNilSize = spec.size {
            resizedImage = self.resizedImage(image, newSize: notNilSize)
        } else {
            resizedImage = image
        }
        
        self.persistentImageStorage.saveImage(spec: ImageSpec(url: spec.url), image: data)
        self.inMemoryImageStorage.saveImage(spec: spec, image: resizedImage)
        
        return image
    }
    
    private func deleteImage(spec spec: ImageSpec) {
        
        self.persistentImageStorage.deleteImage(spec: spec)
        self.inMemoryImageStorage.deleteImage(spec: spec)
    }
    
    private func resizedImage(image: UIImage, newSize: CGSize?) -> UIImage {
        
        guard let size = newSize else {
            return image
        }
        
        let oldSize = image.size
        let xRatio = size.width / oldSize.width
        let yRatio = size.height / oldSize.height
        let ratio = min(xRatio, yRatio)
        let updatedNewSize = CGSizeMake(oldSize.width * ratio, oldSize.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

