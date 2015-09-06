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

    var articlesViewController: ArticlesViewController?
    
    func start() {
        showArticles()
    }
    
    func showArticles() {
        
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.articlesViewController = navigationController.topViewController as? ArticlesViewController
        self.articlesViewController!.model = ArticlesViewModel()
        self.articlesViewController!.screenFlow = self
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func showSearch() {
        
        let searchNavigationController = self.storyboard.instantiateViewControllerWithIdentifier("SearchNav") as! UINavigationController
        
        let searchViewController = searchNavigationController.topViewController as! SearchViewController
        searchViewController.model = SearchViewModel()
        searchViewController.screenFlow = self
        self.articlesViewController!.presentViewController(searchNavigationController, animated: true, completion: nil)
    }
    
    func hideSearch() {
        self.articlesViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}