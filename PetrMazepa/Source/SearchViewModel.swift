//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel: ViewModel {
    
    private var query: String?
    
    var articlesChanged: (() -> Void)?
    
    var articlesCount: Int {
        get {
            return self.contentProvider.articles.count
        }
    }
    
    func requestArticle(index: Int) -> SimpleArticle {
        return self.contentProvider.articles[index]
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        // TODO: apply query
        
        self.articlesChanged!()
    }
}
