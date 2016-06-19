//
//  ArticleCaption.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 6/18/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol DeserializableFromHTML {
    associatedtype ReturnType
    static func deserialize(fromData data: NSData) -> ReturnType?
}

struct ArticleCaption {

    let id: String
    let title: String
    let thumbPath: String
    var saved: Bool = false
    var favourite: Bool = false
    var topOffset: Float = 0.0

    var thumbUrl: NSURL? {
        get {
            let urlString = "http://petrimazepa.com\(self.thumbPath)"
            return NSURL(string: urlString)
        }
    }

}

extension ArticleCaption {

    init(id: String, title: String, thumbPath: String) {
        self.id = id
        self.title = title
        self.thumbPath = thumbPath
    }
}

extension ArticleCaption: DeserializableFromHTML {

    static func deserialize(fromData data: NSData) -> [ArticleCaption]? {
        let helper = TFHpple(data: data, isXML: false)
        let elements = helper.searchWithXPathQuery("//div[@class='row articles']/div")
        var articles = [ArticleCaption]()

        for element in elements {
            guard let element = element as? TFHppleElement else {
                continue
            }

            if let article = convertElement(element) {
                articles.append(article)
            }
        }
        return articles
    }

    private static func convertElement(element: TFHppleElement) -> ArticleCaption? {
        guard
            let aElement = element.searchWithXPathQuery("//a").first as? TFHppleElement,
            let href = aElement.attributes["href"] as? String else {
                return nil
        }

        let imgElement = element.firstChildWithTagName("img")

        guard
            let identifier = identifierFromHref(href),
            let imgTitle = imgElement.attributes["title"] as? String,
            let thumbPath = imgElement.attributes["data-original"] as? String else {
                return nil
        }

        return ArticleCaption(id: identifier, title: imgTitle, thumbPath: thumbPath)
    }

    private static func identifierFromHref(href: String) -> String? {
        guard href.isEmpty == false else {
            return nil
        }

        let components = href[href.startIndex.advancedBy(1)..<href.endIndex].componentsSeparatedByString(".")
        guard components.count == 2 else {
            return nil
        }
        return components.first
    }
}
