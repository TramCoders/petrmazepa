//
//  Networking.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class Networking {
    
    private let session = NSURLSession.sharedSession()
    private let articlesParser = SimpleArticlesParser()
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ([SimpleArticle]?, NSError?) -> ()) {
        
        if count <= 0 || fromIndex < 0 {
            
            completion(nil, nil)
            return
        }
        
        let urlString = "http://petrimazepa.com/ajax/articles/\(fromIndex)/\(count)"
        let url = NSURL(string: urlString)
        
        guard let notNilUrl = url else {
            return
        }
        
        self.session.dataTaskWithURL(notNilUrl) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let notNilData = data else {

                completion(nil, error)
                return
            }
            
            if error != nil {

                completion(nil, error)
                return
            }
            
            let articles = self.articlesParser.parse(notNilData) as! [SimpleArticle]
            completion(articles, nil)
            
        }.resume()
    }
}