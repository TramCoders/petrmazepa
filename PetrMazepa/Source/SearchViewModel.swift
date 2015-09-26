//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel: ViewModel {
    
    private var query = ""
    var articlesChanged: (() -> Void)?
    private var filteredArticles: [SimpleArticle]
    
    private var allArticles: [SimpleArticle] {
        get {
            return self.contentProvider.articles
        }
    }
    
    override init(contentProvider: ContentProvider) {
        
        self.filteredArticles = contentProvider.articles
        super.init(contentProvider: contentProvider)
    }
    
    var articlesCount: Int {
        get {
            return self.filteredArticles.count
        }
    }
    
    func requestThumb(url url: NSURL?) -> UIImage? {
        
        guard let url = url else {
            return nil
        }
        
        let completion = { (image: UIImage?, error: NSError?) in
            
            if let index = self.findArticle(thumbUrl: url) {
                self.thumbImageLoaded!(index: index)
            }
        }
        
        if let image = self.contentProvider.loadImage(url: url, completion: completion) {
            return image
        }
        
        return nil
    }
    
    func requestArticle(index: Int) -> SimpleArticle {
        return self.filteredArticles[index]
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        self.invalidateContent()
        self.articlesChanged!()
    }
    
    private func invalidateContent() {
        
        if self.query == "" {

            self.filteredArticles = self.allArticles
            return
        }
        
        self.filteredArticles = self.allArticles.filter({ (article: SimpleArticle) -> Bool in
            return article.title.containsString(self.query) || article.author.containsString(self.query)
        })
    }
    
    private func findArticle(thumbUrl url: NSURL) -> Int? {
        return self.filteredArticles.indexOf({ $0.thumbUrl == url })
    }
}
