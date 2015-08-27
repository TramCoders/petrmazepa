//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow {
    
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    var articlesViewModel: ArticlesViewModel?
    
    func start() {
        showArticles()
    }
    
    func showArticles() {
        
        let viewController = self.createArticlesViewController()
        self.articlesViewModel = viewController.model
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
    func expandSearch() {
        
        if let notNilArticlesViewModel = self.articlesViewModel {
            notNilArticlesViewModel.searchStateExpanded = true
        }
    }
    
    func collapseSearch() {
        
        if let notNilArticlesViewModel = self.articlesViewModel {
            notNilArticlesViewModel.searchStateExpanded = false
        }
    }
    
    private func createArticlesViewController() -> ArticlesViewController {
        
        let viewController = storyboard.instantiateInitialViewController() as! ArticlesViewController
        viewController.model = ArticlesViewModel(screenFlow: self)
        viewController.searchViewController = self.createSearchViewController()
        return viewController
    }
    
    private func createSearchViewController() -> SearchViewController {
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier("Search") as! SearchViewController
        viewController.model = SearchViewModel(screenFlow: self)
        return viewController
    }
    
}