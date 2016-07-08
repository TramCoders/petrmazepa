//
//  ImageCacheTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

//import XCTest

//func testImageUrl() -> NSURL {
//    return NSURL.init(string: "http://petrimazepa.com/bundles/pim/images/thumbs/8c8d524c7d2adb60297aa511e03d7485.jpeg")!
//}
//
//func testImageData() -> NSData {
//
//    let image = UIImage(named: "chersonesus")!
//    return UIImagePNGRepresentation(image)!
//}
//
//func testImageData1() -> NSData {
//    
//    let image = UIImage(named: "hiroshima")!
//    return UIImagePNGRepresentation(image)!
//}
//
//class TestImageStorage: ImageStorage {
//    
//    private var images = [NSURL: NSData]()
//    
//    func saveImage(url url: NSURL, data: NSData) {
//        self.images[url] = data
//    }
//
//    func loadImage(url url: NSURL) -> NSData? {
//        return self.images[url]
//    }
//}
//
//class TestImageDownloader: ImageDownloader {
//    
//    private let success: Bool
//    
//    init(success: Bool) {
//        self.success = success
//    }
//    
//    func downloadImage(url: NSURL, completion: (NSData?, NSError?) -> ()) {
//        
//        if self.success {
//            completion(testImageData(), nil)
//            
//        } else {
//            completion(nil, nil)
//        }
//    }
//}
//
//class ImageCacheTests: XCTestCase {
//
//    func testThatReturnsFalseAndDownloadsImageIfItIsNotStored() {
//        
//        let storage = TestImageStorage()
//        let imageCache = ImageCache(storages: [storage], downloader: TestImageDownloader(success: true))
//        let expectation = expectationWithDescription("Image has been downloaded")
//        
//        imageCache.requestImage(url: testImageUrl()) { imageData, error, fromCache in
//            
//            XCTAssert(fromCache == false, "A return value must be 'false' for the unstored image")
//            XCTAssert(imageData != nil, "'imageData' must not be 'nil'")
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(1) { (error: NSError?) -> Void in
//            XCTAssert(error == nil, "An image must be downloaded")
//        }
//    }
//    
//    func testThatReturnsTrueAndCorrectImageIfItIsStored() {
//        
//        let image = UIImage(named: "chersonesus")!
//        let imageData = UIImagePNGRepresentation(image)!
//        let storage = TestImageStorage()
//        storage.saveImage(url: testImageUrl(), data: imageData)
//        let imageCache = ImageCache(storages: [storage], downloader: TestImageDownloader(success: true))
//        
//        var resultImageData: NSData?
//
//        imageCache.requestImage(url: testImageUrl()) { imageData, _, fromCache in
//            
//            XCTAssert(fromCache, "A return value must be 'true', because the image is stored")
//            resultImageData = imageData
//        }
//        
//        
//        XCTAssert(resultImageData == imageData, "A return value must be equal to the saved image data")
//    }
//    
//    func testThatReturnsNilImageIfItIsNotStoredAndNetworkingFails() {
//
//        let storage = TestImageStorage()
//        let downloader = TestImageDownloader(success: false)
//        let imageCache = ImageCache(storages: [storage], downloader: downloader)
//        let expectation = expectationWithDescription("A callback is called")
//        
//        imageCache.requestImage(url: testImageUrl()) { data, _, _ in
//            
//            XCTAssert(data == nil, "'data' must be 'nil'")
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(1) { (error) -> () in
//            XCTAssert(error == nil, "The callback must be called")
//        }
//    }
//    
//    func testThatReturnsImageIfItIsNotStoredAndNetworkingSucceeds() {
//        
//        let storage = TestImageStorage()
//        let downloader = TestImageDownloader(success: true)
//        let imageCache = ImageCache(storages: [storage], downloader: downloader)
//        let expectation = expectationWithDescription("A callback is called")
//        
//        imageCache.requestImage(url: testImageUrl()) { data, _, _ in
//            
//            XCTAssert(data != nil, "'data' mustn't be 'nil'")
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(1) { (error) -> () in
//            XCTAssert(error == nil, "The callback must be called")
//        }
//    }
//    
//    func testThatReturnsCorrectImageIfItIsStoredRegardlessNetworkState() {
//        
//        let storage = TestImageStorage()
//        let url = testImageUrl()
//        let data = testImageData()
//        storage.saveImage(url: url, data: data)
//        
//        let downloader = TestImageDownloader(success: false)
//        let imageCache = ImageCache(storages: [storage], downloader: downloader)
//        let expectation = expectationWithDescription("A callback is called")
//        
//        imageCache.requestImage(url: testImageUrl()) { resultData, _, _ in
//            
//            XCTAssert(resultData != nil, "'data' mustn't be 'nil'")
//            XCTAssert(resultData == data, "'data' must be equal to the saved data")
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(1) { (error) -> () in
//            XCTAssert(error == nil, "The callback must be called")
//        }
//    }
//    
//    func testThatIfStorageContainsImageThenNextSorageIsIgnored() {
//        
//        let imageUrl = testImageUrl()
//        let imageData = testImageData()
//        let nextImageData = testImageData1()
//        
//        // previous image storage
//        let storage = TestImageStorage()
//        storage.saveImage(url: imageUrl, data: imageData)
//        
//        // image storage
//        let nextStorage = TestImageStorage()
//        nextStorage.saveImage(url: imageUrl, data: nextImageData)
//        
//        let imageCache = ImageCache(storages: [storage, nextStorage], downloader: TestImageDownloader(success: false))
//        let expectation = expectationWithDescription("A callback is called")
//        
//        imageCache.requestImage(url: imageUrl) { data, _, _ in
//            
//            XCTAssert(data != nil, "'data' must not be 'nil'")
//            XCTAssert(data == imageData, "'data' must be equal to the image data from the first image storage")
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(1) { (error) -> Void in
//            XCTAssert(error == nil, "The callback must be called")
//        }
//    }
//    
//    func testThatIfStorageDoesNotContainImageThenNextStorageIsUsed() {
//        
//        let imageUrl = testImageUrl()
//        let nextImageData = testImageData1()
//        
//        // previous image storage
//        let storage = TestImageStorage()
//        
//        // image storage
//        let nextStorage = TestImageStorage()
//        nextStorage.saveImage(url: imageUrl, data: nextImageData)
//        
//        let imageCache = ImageCache(storages: [storage, nextStorage], downloader: TestImageDownloader(success: false))
//        let expectation = expectationWithDescription("A callback is called")
//        
//        imageCache.requestImage(url: imageUrl) { data, _, _ in
//            
//            XCTAssert(data != nil, "'data' must not be 'nil'")
//            XCTAssert(data == nextImageData, "'data' must be equal to the image data from the second image storage")
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(1) { (error) -> Void in
//            XCTAssert(error == nil, "The callback must be called")
//        }
//    }
//    
//}
