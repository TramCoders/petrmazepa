//
//  NetworkingTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import XCTest
@testable import PetrMazepa

class NetworkingTests: XCTestCase {
    
    let networking = Networking()
    
    func testThatReturnsNilIfRequestedCountIsZero() {
        
        let expectation = expectationWithDescription("Callback is fired")
        
        self.networking.fetchArticles(fromIndex: 5, count: 0) { articles, error in
            
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
        
        self.networking.fetchArticles(fromIndex: -3, count: 1) { articles, error in
            
            XCTAssert(articles == nil, "'articles' must be nil")
            XCTAssert(error == nil, "'error' must be nil")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssert(error == nil, "Callback is not fired")
        }
    }
}
