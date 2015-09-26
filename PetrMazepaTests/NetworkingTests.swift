//
//  NetworkingTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import XCTest

class NetworkingTests: XCTestCase {
    
    let networking = Networking()
    
    func testThatReturnsNilIfRequestedCountIsZero() {
        
        let expectation = expectationWithDescription("Callback is fired")
        
        self.networking.fetchArticles(fromIndex: 5, count: 0) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            XCTAssert(articles == nil, "'articles' must be nil")
            XCTAssert(error == nil, "'error' must be nil")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssert(error == nil, "Callback is not fired")
        }
    }
    
    func testThatReturnsNilIfRequestedFromIndexIsNegative() {
        
        let expectation = expectationWithDescription("Callback is fired")
        
        self.networking.fetchArticles(fromIndex: -3, count: 1) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            XCTAssert(articles == nil, "'articles' must be nil")
            XCTAssert(error == nil, "'error' must be nil")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssert(error == nil, "Callback is not fired")
        }
    }
    
    func testThatReturnsOneArticleIfRequestedCountIsOne() {
        
        let expectation = expectationWithDescription("Callback is fired")
        
        self.networking.fetchArticles(fromIndex: 1, count: 1) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            XCTAssert(articles != nil, "'articles' must not be nil")
            XCTAssert(articles?.count == 1, "'articles' count must be 1")
            XCTAssert(error == nil, "'error' must be nil")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssert(error == nil, "Callback is not fired")
        }
    }
    
    func testThatReturnsTenArticlesIfRequestedCountIsTen() {
        
        let expectation = expectationWithDescription("Callback is fired")
        
        self.networking.fetchArticles(fromIndex: 5, count: 10) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            XCTAssert(articles != nil, "'articles' must not be nil")
            XCTAssert(articles?.count == 10, "'articles' count must be 10")
            XCTAssert(error == nil, "'error' must be nil")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssert(error == nil, "Callback is not fired")
        }
    }
    
}
