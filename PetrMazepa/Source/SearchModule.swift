//
//  SearchModule.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 5/7/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol ISearchView: class {
    func reloadArticles()
}

protocol ISearchViewModel: class {

    var filter: SearchFilter { get }
    var articlesCount: Int { get }
    
    func viewWillAppear()
    func viewWillDisappear()
    func didChangeQuery(query: String)
    func closeTapped()
    func filterTapped(filter: SearchFilter)
    func articleTapped(indexPath: NSIndexPath)
    func searchedArticleModel(indexPath indexPath: NSIndexPath) -> SimpleArticleCellModel
}
