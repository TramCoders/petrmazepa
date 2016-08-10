//
//  Article.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import Foundation

protocol DeserializableFromHTML {
    associatedtype ReturnType
    static func deserialize(fromData data: NSData) -> ReturnType?
}

final class Article {
    
    let id: String
    let title: String
    let thumbPath: String
    var saved: Bool
    var favourite: Bool
    var topOffset: Double
    
    var thumbUrl: NSURL? {
        
        get {
            let urlString = "http://petrimazepa.com\(self.thumbPath)"
            return NSURL(string: urlString)
        }
    }
    
    convenience init(id: String, title: String, thumbPath: String) {
        self.init(id: id, title: title, thumbPath: thumbPath, saved: false, favourite: false, topOffset: 0.0)
    }
    
    init(id: String, title: String, thumbPath: String, saved: Bool, favourite: Bool, topOffset: Double) {
        
        self.id = id
        self.title = title
        self.thumbPath = thumbPath
        self.saved = saved
        self.favourite = favourite
        self.topOffset = topOffset
    }
    
    
}

extension Article: ManagedObjectConvertable {
    
    convenience init(_ object: MOArticle) {
        self.init(id: object.id!, title: object.title!, thumbPath: object.thumbPath!, saved: object.details != nil, favourite: object.favourite!.boolValue, topOffset: object.topOffset!.doubleValue)
    }
}

extension Article: Hashable {
    
    var hashValue: Int {
        return self.id.hashValue
    }
}

func ==(lhs: Article, rhs: Article) -> Bool {
    return lhs.id == rhs.id
}

extension Article: DeserializableFromHTML {
    
    static func deserialize(fromData data: NSData) -> [Article]? {
        let helper = TFHpple(data: data, isXML: false)
        let elements = helper.searchWithXPathQuery("//div[@class='row articles']/div")
        var articles = [Article]()
        
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
    
    private static func convertElement(element: TFHppleElement) -> Article? {
        guard
            let aElement = element.searchWithXPathQuery("//a").first as? TFHppleElement,
            let href = aElement.attributes["href"] as? String,
            let identifier = identifierFromHref(href) else {
                return nil
        }
        
        let imgElement = element.firstChildWithTagName("img")
        
        guard
            let imgTitle = imgElement.attributes["title"] as? String,
            let thumbPath = imgElement.attributes["data-original"] as? String else {
                return nil
        }
        
        return Article(id: identifier, title: imgTitle, thumbPath: thumbPath)
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
