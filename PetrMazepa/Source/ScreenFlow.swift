//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow: SearchPresenter, SearchDismisser, ArticleDetailsPresenter, ArticleDetailsDismisser {
    
    private enum Screen {
        
        case None, Articles, Search, ArticleDetails
        
        var description: String {
            
            switch self {
            case .None: return "None"
            case .Articles: return "Articles"
            case .Search: return "Search"
            case .ArticleDetails: return "ArticleDetails"
            }
        }
    }
    
    private let window: UIWindow
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    
    private let imageCache: ImageCache
    private let contentProvider: ContentProvider
    
    private var screenStack: [Screen]
    
    init() {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = self.storyboard.instantiateInitialViewController() as! UINavigationController
        
        let networking = Networking()
        self.contentProvider = ContentProvider(networking: networking)
        
        let inMemoryImageStorage = InMemoryImageStorage()
        let persistentImageStorage = PersistentImageStorage()
        self.imageCache = ImageCache(storages: [inMemoryImageStorage, persistentImageStorage], downloader: networking)
        
        self.screenStack = [Screen]()
    }
    
    func start() {
        self.presentArticles()
    }
    
    func presentArticles() {
        
        guard self.currentScreen() == .None else {
            return
        }
        
        let articlesViewController = self.navigationController.topViewController as! ArticlesViewController
        
        articlesViewController.model = ArticlesViewModel(imageCache: self.imageCache, articleStorage: self.contentProvider, articlesFetcher: self.contentProvider, searchPresenter: self, articleDetailsPresenter: self)

        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        self.pushScreen(.Articles)
    }

    func presentSearch() {
        
        guard self.currentScreen() == .Articles else {
            return
        }
        
        let searchNavigationController = self.storyboard.instantiateViewControllerWithIdentifier("SearchNav") as! UINavigationController
        let searchViewController = searchNavigationController.topViewController as! SearchViewController
        searchViewController.model = SearchViewModel(imageCache: self.imageCache, articleStorage: self.contentProvider, searchDismisser: self, articleDetailsPresenter: self)
        
        let articlesViewController = self.navigationController.topViewController as! ArticlesViewController
        articlesViewController.presentViewController(searchNavigationController, animated: true, completion: nil)
        
        self.pushScreen(.Search)
    }
    
    func dismissSearch() {

        guard self.currentScreen() == .Search else {
            return
        }
        
        let articlesViewController = self.navigationController.topViewController as! ArticlesViewController
        articlesViewController.dismissViewControllerAnimated(true, completion: nil)
        
        self.popScreen()
    }
    
    func presentArticleDetails(article: Article) {
        
        guard self.currentScreen() == .Articles || self.currentScreen() == .Search else {
            return
        }
        
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("Details") as! ArticleDetailsViewController
        viewController.model = ArticleDetailsViewModel(articleDetailsDismisser: self)
        
        if self.currentScreen() == .Articles {
            self.navigationController.pushViewController(viewController, animated: true)
            
        } else if self.currentScreen() == .Search {
            
            let articlesViewController = self.navigationController.topViewController as! ArticlesViewController
            let searchNavigationController = articlesViewController.presentedViewController as! UINavigationController
            searchNavigationController.pushViewController(viewController, animated: true)
        }
        
        self.pushScreen(.ArticleDetails)
    }
    
    func dismissArticleDetails() {

        guard self.currentScreen() == .ArticleDetails else {
            return
        }
        
        self.popScreen()
        
        if self.currentScreen() == .Articles {
            self.navigationController.popViewControllerAnimated(true)
            
        } else if self.currentScreen() == .Search {
            
            let articlesViewController = self.navigationController.topViewController as! ArticlesViewController
            let searchNavigationController = articlesViewController.presentedViewController as! UINavigationController
            searchNavigationController.popViewControllerAnimated(true)
        }
    }
    
    private func currentScreen() -> Screen {
        
        if let currentScreen = self.screenStack.last {
            return currentScreen
        } else {
            return .None
        }
    }
    
    private func pushScreen(screen: Screen) {
        
        guard screen != .None else {
            return
        }
        
        self.screenStack.append(screen)
    }
    
    private func popScreen() {
        
        guard self.screenStack.count > 1 else {
            return
        }
        
        self.screenStack.removeLast()
    }
}
