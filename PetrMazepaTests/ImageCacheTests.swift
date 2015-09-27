//
//  ImageCacheTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import XCTest

class ImageCacheTests: XCTestCase {

    func testThatReturnsFalseIfDoesntContainUrl() {
        
        let imageCache = ImageCache(images: [NSURL : NSData]())
        let url = NSURL.init(string: "http://petrimazepa.com/bundles/pim/images/thumbs/8c8d524c7d2adb60297aa511e03d7485.jpeg")!
        let exists = imageCache.requestImage(url: url) { (_, _) -> () in /* do nothing*/ }
        
        XCTAssert(exists == false, "A return value must be 'false' for a nonexistent URL")
    }
    
    func testThatReturnsTrueAndCorrectImageIfContainsUrl() {
        
        let url = NSURL.init(string: "http://petrimazepa.com/bundles/pim/images/thumbs/8c8d524c7d2adb60297aa511e03d7485.jpeg")!
        let image = UIImage(named: "chersonesus")!
        let imageData = UIImagePNGRepresentation(image)!
        let imageCache = ImageCache(images: [url : imageData])
        
        var resultImageData: NSData?

        let exists = imageCache.requestImage(url: url) { (imageData: NSData?, _) -> () in
            resultImageData = imageData
        }
        
        XCTAssert(exists == true, "A return value must be 'true' for an existent URL")
        XCTAssert(resultImageData == imageData, "A return value must be equal to the saved image data")
    }
    
}
