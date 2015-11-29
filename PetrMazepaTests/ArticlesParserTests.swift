//
//  ArticlesParserTests.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit
import XCTest

class ArticlesParserTests: XCTestCase {

    var parser = ArticlesParser()

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
        
        let article0 = articles[0] as! Article
        let article1 = articles[1] as! Article
        
        XCTAssertTrue(article0.id == "diggit")
        XCTAssertTrue(article0.title == "Исповедь шахтёра из «ДНР»: «Не проходит и недели, чтобы кто-то из нас не погиб»")
        
        XCTAssertTrue(article1.id == "novitsalite")
        XCTAssertTrue(article1.title == "Слепота Европы")
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
