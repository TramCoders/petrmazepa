//
//  Networking.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class Networking: ImageDownloader, ArticlesFetcher, ArticleDetailsFetcher {
    
    private let session = NSURLSession.sharedSession()
    private let baseUrl = "http://petrimazepa.com"
    
    private let articlesParser = ArticlesParser()
    private let articleDetailsParser = ArticleDetailsParser()
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {
        
        guard let url = self.fetchArticlesUrl(fromIndex: fromIndex, count: count) else {

            completion(nil, nil)
            return
        }
        
        self.session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> () in
            
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
    
    func fetchArticleDetails(id id: String, completion: ArticleDetailsFetchHandler) {
        
        let urlString = "\(self.baseUrl)/\(id).html"
        let url = NSURL(string: urlString)!
        
        self.session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> () in
            
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
        
        let request = NSURLRequest(URL: url)
        self.session.downloadTaskWithRequest(request) { (fileUrl: NSURL?, _, error: NSError?) -> () in
            
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
    
    private func fetchArticlesUrl(fromIndex fromIndex: Int, count: Int) -> NSURL? {

        if count <= 0 || fromIndex < 0 {
            return nil
        }
        
        let urlString = "\(self.baseUrl)/ajax/articles/\(fromIndex)/\(count)"
        return NSURL(string: urlString)
    }
}
