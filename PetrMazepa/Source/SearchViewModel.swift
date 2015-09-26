//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel: ViewModel {
    
    private var articles: [SimpleArticle]?
    private var query: String?
    
    var articlesChanged: (() -> Void)?
    
    var articlesCount: Int {
        get {
            return self.contentProvider.articles.count
        }
    }
    
    func requestArticle(index: Int) -> (thumb: UIImage?, title: String, author: String) {
        
        let articles = self.contentProvider.articles[index]
        return (UIImage(named: "chersonesus"), articles.title, articles.author)
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        // TODO: apply query
        
        self.articlesChanged!()
    }
}
