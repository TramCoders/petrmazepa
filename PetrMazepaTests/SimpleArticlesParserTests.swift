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

    var parser = SimpleArticlesParser()
    
    override func setUp() {
        
        super.setUp()
        //
    }
    
    override func tearDown() {
        //
        super.tearDown()
    }

//    func test
    
    /**
    http://petrimazepa.com/ajax/articles/0/2 -> returns 2 articles starting from the most recent
    */
    
    
    func testThatReturnsEmptyArrayIfInputIsNil() {
        
        let articles = parser.parse(nil)
        XCTAssertTrue(articles.count == 0, "An amount of articles must be 0")
    }
    
    func testThatReturnsCorrectArticlesCount() {
        
        let html = loadHtml("articles")
        let articles = parser.parse(html)
        XCTAssertTrue(articles.count == 2, "An amount of articles must be 2")
    }
    
    func testThatReturnCorrectArticles() {
        
        let html = loadHtml("articles")
        let articles = parser.parse(html)
        
        let article1 = articles[1] as SimpleArticle;
        
        XCTAssertTrue(article1.id == "remember", "Id of article #1 must be 'remember'")
    }
    
    private func loadHtml(fileName: String) -> NSData? {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(fileName, ofType: "html")
        
        if let content = NSData(contentsOfFile: path!) {
            return content
        }
        
        return nil
    }
}
