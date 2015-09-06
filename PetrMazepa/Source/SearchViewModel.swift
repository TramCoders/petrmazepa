//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel {
    
    private var articles: [SimpleArticle]?
    private var query: String?
    
    var articlesChanged: (() -> Void)?
    
    var articlesCount: Int {
        get {
            return 10
        }
    }
    
    func requestArticle(index: Int) -> (thumb: UIImage?, title: String, author: String) {
        return (UIImage(named: "chersonesus"), "TitleTitle", "AuthorAuthor")
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        // TODO: apply query
        
        self.articlesChanged!()
    }
}
