//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow: NSObject, UITabBarControllerDelegate, ArticleDetailsPresenter, ArticleDetailsDismisser, ArticleSharer {
    
    private let window: UIWindow
    private let storyboard: UIStoryboard
    
    private let tabBarController: UITabBarController
    private var currentNavigationController: UINavigationController
    private var currentViewController: UIViewController
    
    private let imageCache: ImageCache
    private let contentProvider: ContentProvider
    private let networking: Networking
    private let settings: Settings
    
    override init() {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window.tintColor = UIColor(red: 0.933, green: 0.427, blue: 0.439, alpha: 1.0)
        self.window.layer.cornerRadius = 4.0
        self.window.layer.masksToBounds = true
        
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.tabBarController = self.storyboard.instantiateInitialViewController() as! UITabBarController
        self.currentNavigationController = self.tabBarController.viewControllers!.first as! UINavigationController
        self.currentViewController = self.tabBarController
        
        self.settings = Settings()
        self.networking = Networking()
        self.contentProvider = ContentProvider(networking: self.networking)
        
        let inMemoryImageStorage = InMemoryImageStorage()
        let persistentImageStorage = PersistentImageStorage()
        self.imageCache = ImageCache(inMemoryImageStorage: inMemoryImageStorage, persistentImageStorage: persistentImageStorage, downloader: self.networking)
        
        super.init()
        
        self.tabBarController.delegate = self
        
        guard let navigationControllers = self.tabBarController.viewControllers as? [UINavigationController] else {
            return
        }
        
        let viewControllers = navigationControllers.map({ $0.viewControllers.first! })
        
        if let articlesViewController = viewControllers[0] as? ArticlesViewController {
            articlesViewController.model = self.createArticlesViewModel()
        }
        
        if let searchViewController = viewControllers[1] as? SearchViewController {
            searchViewController.model = self.createSearchViewModel()
        }
        
        if let settingsViewController = viewControllers[2] as? SettingsViewController {
            settingsViewController.model = self.createSettingsViewModel()
        }
    }
    
    func start() {
        self.presentArticles()
    }
    
    func presentArticles() {
        
        let articlesViewController = self.currentNavigationController.topViewController as! ArticlesViewController
        articlesViewController.model = self.createArticlesViewModel()

        self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
        
        self.currentViewController = articlesViewController
    }
    
    func presentArticleDetails(article: Article) {
        
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("Details") as! ArticleDetailsViewController
        viewController.model = self.createArticleDetailsViewModel(article: article)
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
        
        if let navigationController = viewController as? UINavigationController {
            self.currentNavigationController = navigationController
        }
    }
    
    private func createArticlesViewModel() -> ArticlesViewModel {
        
        return ArticlesViewModel(settings: self.settings, imageGateway: self.imageCache, articleStorage: self.contentProvider, articlesFetcher: self.contentProvider, articleDetailsPresenter: self)
    }
    
    private func createArticleDetailsViewModel(article article: Article) -> ArticleDetailsViewModel {
        
        return ArticleDetailsViewModel(article: article, imageCache: self.imageCache, articleDetailsFetcher: self.contentProvider, favouriteMaker: self.contentProvider, articleDetailsDismisser: self, articleSharer: self)
    }
    
    private func createSearchViewModel() -> SearchViewModel {
        
        return SearchViewModel(imageGateway: self.imageCache, articleStorage: self.contentProvider, favouriteArticleStorage: self.contentProvider, articleDetailsPresenter: self)
    }
    
    private func createSettingsViewModel() -> SettingsViewModel {

        return SettingsViewModel(settings: self.settings)
    }
}
