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
    
    let imageCache: ImageCache
    let contentProvider: ContentProvider
    
    init() {
        
        let networking = Networking()
        self.contentProvider = ContentProvider(networking: networking)
        
        let inMemoryImageStorage = InMemoryImageStorage()
        let persistentImageStorage = PersistentImageStorage()
        self.imageCache = ImageCache(storages: [inMemoryImageStorage, persistentImageStorage], downloader: networking)
    }
    
    func start() {
        showArticles()
    }
    
    func showArticles() {
        
        let navigationController = self.storyboard.instantiateInitialViewController() as! UINavigationController
        self.articlesViewController = navigationController.topViewController as? ArticlesViewController
        
        self.articlesViewController!.model = ArticlesViewModel(imageCache: self.imageCache, articleStorage: self.contentProvider, articlesFetcher: self.contentProvider)

        self.articlesViewController!.screenFlow = self
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func showSearch() {
        
        let searchNavigationController = self.storyboard.instantiateViewControllerWithIdentifier("SearchNav") as! UINavigationController
        
        let searchViewController = searchNavigationController.topViewController as! SearchViewController
        searchViewController.model = SearchViewModel(imageCache: self.imageCache, articleStorage: self.contentProvider)
        searchViewController.screenFlow = self
        self.articlesViewController!.presentViewController(searchNavigationController, animated: true, completion: nil)
    }
    
    func hideSearch() {
        self.articlesViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func showArticleDetails(index index: Int) {
        
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("article_details") as! ArticleDetailsViewController
        viewController.model = ArticleDetailsViewModel()
        self.window.rootViewController?.showViewController(viewController, sender: nil)
    }
}
