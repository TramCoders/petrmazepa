//
//  ArticleDetails.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

final class ArticleDetails {
    
    let htmlText: String
    
    init(htmlText: String) {
        self.htmlText = htmlText
    }
}

extension ArticleDetails: DeserializableFromHTML {
    
    static func deserialize(fromData data: NSData) -> ArticleDetails? {
        let hpple = TFHpple(data: data, isXML: false)
        
        guard
            let htmlTextElement = hpple.searchWithXPathQuery("//div[@class='mainContent']").first as? TFHppleElement else {
                return nil
        }
        
        let htmlText = htmlTextElement.raw.stringByReplacingOccurrencesOfString("width=\"788\"", withString: "width=\"100%%\"")
        return ArticleDetails(htmlText: htmlText)
    }
}
