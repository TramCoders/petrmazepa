//
//  SimpleArticlesParser.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import Foundation

class SimpleArticlesParser : NSObject, NSXMLParserDelegate {
    
    func parse(html: NSData?) -> Array<SimpleArticle> {
        
        if html == nil {
            return []
        }
        
        // TODO
        
        return []
    }
}
