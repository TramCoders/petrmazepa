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

    func testThatReturnsEmptyArrayIfInputIsNil() {
        
        let articles = parser.parse(nil)
        XCTAssertTrue(articles.count == 0)
    }
    
    func testThatReturnsCorrectArticlesCount() {
        
        let html = loadHtml("articles")
        let articles = parser.parse(html)
        
        XCTAssertTrue(articles.count == 2)
    }
    
    func testThatReturnsZeroArticlesForRandomHtml() {
        
        let html = loadHtml("random_page")
        let articles = parser.parse(html)
        
        XCTAssertTrue(articles.count == 0)
    }
    
    func testThatReturnsCorrectArticles() {
        
        let html = loadHtml("articles")
        let articles = parser.parse(html)
        
        let article0 = articles[0] as SimpleArticle
        let article1 = articles[1] as SimpleArticle
        
        XCTAssertTrue(article0.id == "shadowdragon")
        XCTAssertTrue(article0.title == "Тень Поднебесной или что бывает, когда у дракона пустеет казна")
        
        XCTAssertTrue(article1.id == "freeman")
        XCTAssertTrue(article1.title == "Свободу Пивоварову!")
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
