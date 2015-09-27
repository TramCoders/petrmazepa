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
        
        guard let url = self.fetchArticlesUrl(fromIndex: fromIndex, count: count) else {

            completion(nil, nil)
            return
        }
        
        self.session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
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
    
    private func fetchArticlesUrl(fromIndex fromIndex: Int, count: Int) -> NSURL? {

        if count <= 0 || fromIndex < 0 {
            return nil
        }
        
        let urlString = "http://petrimazepa.com/ajax/articles/\(fromIndex)/\(count)"
        return NSURL(string: urlString)
    }
}