//
//  ImageCacheTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import XCTest

class ImageCacheTests: XCTestCase {

    // FIXME: it shouldn't go to the network
    func testThatReturnsFalseAndDownloadsImageIfDoesntContainUrl() {
        
        let storage = InMemoryImageStorage()
        let imageCache = ImageCache(storages: [storage])
        let url = NSURL.init(string: "http://petrimazepa.com/bundles/pim/images/thumbs/8c8d524c7d2adb60297aa511e03d7485.jpeg")!
        let expectation = expectationWithDescription("Image has been downloaded")
        
        let exists = imageCache.requestImage(url: url) { (imageData: NSData?, _) -> () in
            
            XCTAssert(imageData != nil, "'imageData' mustn't be 'nil'")
            expectation.fulfill()
        }
        
        XCTAssert(exists == false, "A return value must be 'false' for a nonexistent URL")
        
        waitForExpectationsWithTimeout(3) { (error: NSError?) -> Void in
            XCTAssert(error == nil, "An image must be downloaded")
        }
    }
    
    func testThatReturnsTrueAndCorrectImageIfContainsUrl() {
        
        let url = NSURL.init(string: "http://petrimazepa.com/bundles/pim/images/thumbs/8c8d524c7d2adb60297aa511e03d7485.jpeg")!
        let image = UIImage(named: "chersonesus")!
        let imageData = UIImagePNGRepresentation(image)!
        let storage = InMemoryImageStorage()
        storage.saveImage(url: url, data: imageData)
        let imageCache = ImageCache(storages: [storage])
        
        var resultImageData: NSData?

        let exists = imageCache.requestImage(url: url) { (imageData: NSData?, _) -> () in
            resultImageData = imageData
        }
        
        XCTAssert(exists == true, "A return value must be 'true' for an existent URL")
        XCTAssert(resultImageData == imageData, "A return value must be equal to the saved image data")
    }
    
}
