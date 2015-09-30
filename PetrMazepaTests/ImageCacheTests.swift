//
//  ImageCacheTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import XCTest

func testImageUrl() -> NSURL {
    return NSURL.init(string: "http://petrimazepa.com/bundles/pim/images/thumbs/8c8d524c7d2adb60297aa511e03d7485.jpeg")!
}

func testImageData() -> NSData {

    let image = UIImage(named: "chersonesus")!
    return UIImagePNGRepresentation(image)!
}

class TestImageStorage: ImageStorage {
    
    private var images = [NSURL: NSData]()
    
    func saveImage(url url: NSURL, data: NSData) {
        self.images[url] = data
    }

    func loadImage(url url: NSURL) -> NSData? {
        return self.images[url]
    }
}

class TestImageDownloader: ImageDownloader {
    
    private let success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func downloadImage(url: NSURL, completion: (NSData?, NSError?) -> ()) {
        
        if self.success {
            completion(testImageData(), nil)
            
        } else {
            completion(nil, nil)
        }
    }
}

class ImageCacheTests: XCTestCase {

    func testThatReturnsFalseAndDownloadsImageIfDoesntContainUrl() {
        
        let storage = TestImageStorage()
        let imageCache = ImageCache(storages: [storage], downloader: TestImageDownloader(success: true))
        let expectation = expectationWithDescription("Image has been downloaded")
        
        let exists = imageCache.requestImage(url: testImageUrl()) { (imageData: NSData?, _) -> () in
            
            XCTAssert(imageData != nil, "'imageData' mustn't be 'nil'")
            expectation.fulfill()
        }
        
        XCTAssert(exists == false, "A return value must be 'false' for a nonexistent URL")
        
        waitForExpectationsWithTimeout(1) { (error: NSError?) -> Void in
            XCTAssert(error == nil, "An image must be downloaded")
        }
    }
    
    func testThatReturnsTrueAndCorrectImageIfContainsUrl() {
        
        let image = UIImage(named: "chersonesus")!
        let imageData = UIImagePNGRepresentation(image)!
        let storage = TestImageStorage()
        storage.saveImage(url: testImageUrl(), data: imageData)
        let imageCache = ImageCache(storages: [storage], downloader: TestImageDownloader(success: true))
        
        var resultImageData: NSData?

        let exists = imageCache.requestImage(url: testImageUrl()) { (imageData: NSData?, _) -> () in
            resultImageData = imageData
        }
        
        XCTAssert(exists == true, "A return value must be 'true' for an existent URL")
        XCTAssert(resultImageData == imageData, "A return value must be equal to the saved image data")
    }
    
    func testThatReturnsNilImageIfDoesntContainUrlAndNetworkingFails() {

        let storage = TestImageStorage()
        let downloader = TestImageDownloader(success: false)
        let imageCache = ImageCache(storages: [storage], downloader: downloader)
        let expectation = expectationWithDescription("A callback is called")
        
        imageCache.requestImage(url: testImageUrl()) { (data, error) -> () in
            
            XCTAssert(data == nil, "'data' must be 'nil'")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { (error) -> () in
            XCTAssert(error == nil, "The callback must be called")
        }
    }
    
    func testThatReturnsImageIfDoesntContainUrlAndNetworkingSucceeds() {
        
        let storage = TestImageStorage()
        let downloader = TestImageDownloader(success: true)
        let imageCache = ImageCache(storages: [storage], downloader: downloader)
        let expectation = expectationWithDescription("A callback is called")
        
        imageCache.requestImage(url: testImageUrl()) { (data, error) -> () in
            
            XCTAssert(data != nil, "'data' mustn't be 'nil'")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { (error) -> () in
            XCTAssert(error == nil, "The callback must be called")
        }
    }
    
    func testThatReturnsCorrectImageIfContainsUrlRegardlessNetworkState() {
        
        let storage = TestImageStorage()
        let url = testImageUrl()
        let data = testImageData()
        storage.saveImage(url: url, data: data)
        
        let downloader = TestImageDownloader(success: false)
        let imageCache = ImageCache(storages: [storage], downloader: downloader)
        let expectation = expectationWithDescription("A callback is called")
        
        imageCache.requestImage(url: testImageUrl()) { (resultData, error) -> () in
            
            XCTAssert(resultData != nil, "'data' mustn't be 'nil'")
            XCTAssert(resultData == data, "'data' must be equal to the saved data")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { (error) -> () in
            XCTAssert(error == nil, "The callback must be called")
        }
    }
    
}
