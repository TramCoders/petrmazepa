//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow: NSObject, ArticleDetailsPresenter, ArticleDetailsDismisser, ArticleSharer, UITabBarControllerDelegate {
    
    private let window: UIWindow
    private let storyboard: UIStoryboard
    
    private let tabBarController: UITabBarController
    private var currentNavigationController: UINavigationController
    private var currentViewController: UIViewController
    
    private let imageCache: ImageCache
    private let contentProvider: ContentProvider
    private let networking: Networking
    
    override init() {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window.tintColor = UIColor(red: 0.933, green: 0.427, blue: 0.439, alpha: 1.0)
        self.window.layer.cornerRadius = 4.0
        self.window.layer.masksToBounds = true
        
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.tabBarController = self.storyboard.instantiateInitialViewController() as! UITabBarController
        self.currentNavigationController = self.tabBarController.viewControllers!.first as! UINavigationController
        self.currentViewController = self.tabBarController
        
        self.networking = Networking()
        self.contentProvider = ContentProvider(networking: self.networking)
        
        let inMemoryImageStorage = InMemoryImageStorage()
        let persistentImageStorage = PersistentImageStorage()
        self.imageCache = ImageCache(inMemoryImageStorage: inMemoryImageStorage, persistentImageStorage: persistentImageStorage, downloader: self.networking)
        
        super.init()
        self.tabBarController.delegate = self
    }
    
    func start() {
        self.presentArticles()
    }
    
    func presentArticles() {
        
        let articlesViewController = self.currentNavigationController.topViewController as! ArticlesViewController
        articlesViewController.model = ArticlesViewModel(imageGateway: self.imageCache, articleStorage: self.contentProvider, articlesFetcher: self.contentProvider, articleDetailsPresenter: self)

        self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
        
        self.currentViewController = articlesViewController
    }
    
    func presentArticleDetails(article: Article) {
        
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("Details") as! ArticleDetailsViewController
        viewController.model = ArticleDetailsViewModel(article: article, imageCache: self.imageCache, articleDetailsFetcher: self.contentProvider, favouriteMaker: self.contentProvider, articleDetailsDismisser: self, articleSharer: self)
        
        self.currentNavigationController.pushViewController(viewController, animated: true)
        self.currentViewController = viewController
    }
    
    func dismissArticleDetails() {

        self.currentNavigationController.popViewControllerAnimated(true)
        self.currentViewController = self.currentNavigationController.topViewController!
    }
    
    func shareArticle(article: Article) {

        guard let url = self.networking.articleDetailsUrl(articleId: article.id) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.currentViewController.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        self.currentNavigationController = viewController as! UINavigationController
        let innerViewController = self.currentNavigationController.topViewController
        
        if let articlesViewController = innerViewController as? ArticlesViewController {
            
            // TODO:
            
        } else if let searchViewController = innerViewController as? SearchViewController {
            
            searchViewController.model = SearchViewModel(imageGateway: self.imageCache, articleStorage: self.contentProvider, favouriteArticleStorage: self.contentProvider, articleDetailsPresenter: self)
            
        } else if let settingsViewController = innerViewController as? SettingsViewController {
            
            // TODO:
        }
    }
}
