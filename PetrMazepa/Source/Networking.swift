//
//  Networking.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ActivityIndicator {
    
    init() {
        self.activities = 0
    }
    
    private var activities: Int {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = self.activities > 0
        }
    }
    
    func increment() {
        self.activities++
    }
    
    func decrement() {
        self.activities--
    }
}

class Networking: ImageDownloader, ArticlesFetcher, ArticleDetailsFetcher {
    
    private let session: NSURLSession
    
    private let activityIndicator = ActivityIndicator()
    private let baseUrl = "http://petrimazepa.com"
    
    private let articlesParser = ArticlesParser()
    private let articleDetailsParser = ArticleDetailsParser()
    
    init() {
        
        // config
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 5.0
        config.timeoutIntervalForResource = 10.0
        
        // session
        self.session = NSURLSession(configuration: config)
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {
        
        guard let url = self.articlesUrl(fromIndex: fromIndex, count: count) else {

            completion(nil, nil)
            return
        }
        
        self.activityIndicator.increment()

        self.session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> () in
            
            self.activityIndicator.decrement()
            
            guard let notNilData = data else {

                completion(nil, error)
                return
            }
            
            if error != nil {

                completion(nil, error)
                return
            }
            
            let articles = self.articlesParser.parse(notNilData) as! [Article]
            completion(articles, nil)
            
        }.resume()
    }
    
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler) {
        
        guard let url = self.articleDetailsUrl(articleId: article.id) else {

            completion(nil, nil)
            return
        }
        
        self.activityIndicator.increment()
        
        self.session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> () in
            
            self.activityIndicator.decrement()
            
            guard let notNilData = data else {
                
                completion(nil, error)
                return
            }
            
            if error != nil {
                
                completion(nil, error)
                return
            }
            
            let details = self.articleDetailsParser.parse(notNilData)
            completion(details, nil)
            
        }.resume()
    }
    
    func downloadImage(url: NSURL, completion: ImageDownloadHandler) {
        
        self.activityIndicator.increment()
        
        let request = NSURLRequest(URL: url)
        self.session.downloadTaskWithRequest(request) { (fileUrl: NSURL?, _, error: NSError?) -> () in
            
            self.activityIndicator.decrement()
            
            guard let notNilFileUrl = fileUrl else {
                
                completion(nil, error)
                return
            }
            
            if let imageData = NSData(contentsOfURL: notNilFileUrl) {
                completion(imageData, error)
            } else {
                completion(nil, error)
            }

        }.resume()
    }
    
    func articleDetailsUrl(articleId id: String) -> NSURL? {
        return NSURL(string: "\(self.baseUrl)/\(id).html")
    }
    
    private func articlesUrl(fromIndex fromIndex: Int, count: Int) -> NSURL? {

        if count <= 0 || fromIndex < 0 {
            return nil
        }
        
        let urlString = "\(self.baseUrl)/ajax/articles/\(fromIndex)/\(count)"
        return NSURL(string: urlString)
    }
}
