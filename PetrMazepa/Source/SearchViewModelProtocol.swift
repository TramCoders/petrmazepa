//
//  SearchViewModelProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol SearchViewModelProtocol: class {
    
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
