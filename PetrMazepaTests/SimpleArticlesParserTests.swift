//
//  SimpleArticlesParserTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit
import XCTest

class SimpleArticlesParserTests: XCTestCase {

    var parser: SimpleArticlesParser = SimpleArticlesParser()
    
    override func setUp() {
        super.setUp()
        parser = SimpleArticlesParser()
    }
    
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

//    func test
    
    func testThatReturnsEmptyArrayIfInputIsNil() {
        
        var articles = parser.parse(nil)
        XCTAssert(articles.count == 0, "Amount of articles must be 0")
    }
}
