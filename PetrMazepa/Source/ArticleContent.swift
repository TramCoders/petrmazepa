//
//  ArticleContent.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 6/18/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

struct ArticleContent {
    let htmlText: String
}

extension ArticleContent: DeserializableFromHTML {

    static func deserialize(fromData data: NSData) -> ArticleContent? {
        let hpple = TFHpple(data: data, isXML: false)

        guard
            let htmlTextElement = hpple.searchWithXPathQuery("//div[@class='mainContent']").first as? TFHppleElement else {
            return nil
        }

        let htmlText = htmlTextElement.raw.stringByReplacingOccurrencesOfString("width=\"788\"", withString: "width=\"100%%\"")
        return ArticleContent(htmlText: htmlText)
    }
}
