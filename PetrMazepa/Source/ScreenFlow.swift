//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow: NSObject, ArticleDetailsPresenter, SettingsPresenter, SearchPresenter, ArticleDetailsDismisser, SettingsDismisser, SearchDismisser, ArticleSharer {
    
    private let window: UIWindow
    private let storyboard: UIStoryboard
    
    private var mainNavigationController: UINavigationController
    private var currentNavigationController: UINavigationController
    private var currentViewController: UIViewController
    
    private let imageCache: ImageCache
    private let contentProvider: ContentProvider
    private let networking: Networking
    private let settings: Settings
    
    override init() {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window.tintColor = UIColor(red: 0.933, green: 0.427, blue: 0.439, alpha: 1.0)
        
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mainNavigationController = self.storyboard.instantiateInitialViewController() as! UINavigationController
        self.currentNavigationController = self.mainNavigationController
        self.currentViewController = self.mainNavigationController
        
        self.settings = Settings()
        self.networking = Networking()
        self.contentProvider = ContentProvider(networking: self.networking)
        
        let inMemoryImageStorage = InMemoryImageStorage()
        let persistentImageStorage = PersistentImageStorage()
        self.imageCache = ImageCache(inMemoryImageStorage: inMemoryImageStorage, persistentImageStorage: persistentImageStorage, downloader: self.networking)
        
        super.init()
    }
    
    func start() {
        self.presentArticles()
    }
    
    func presentArticles() {
        
        let articlesViewController = self.currentNavigationController.topViewController as! ArticlesViewController
        articlesViewController.model = self.createArticlesViewModel()

        self.window.rootViewController = self.currentNavigationController
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
    
    func presentSettings() {
        
        let navigationController = self.storyboard.instantiateViewControllerWithIdentifier("SettingsNav") as! UINavigationController
        let settingsViewController = navigationController.topViewController as! SettingsViewController
        settingsViewController.model = self.createSettingsViewModel()
        self.currentNavigationController.presentViewController(navigationController, animated: true, completion: nil)
        self.currentNavigationController = navigationController
    }
    
    func dismissSettings() {
        
        self.mainNavigationController.dismissViewControllerAnimated(true, completion: nil)
        self.currentNavigationController = self.mainNavigationController
    }
    
    func presentSearch() {
        
        let navigationController = self.storyboard.instantiateViewControllerWithIdentifier("SearchNav") as! UINavigationController
        let searchViewController = navigationController.topViewController as! SearchViewController
        searchViewController.model = self.createSearchViewModel()
        self.currentNavigationController.presentViewController(navigationController, animated: true, completion: nil)
        self.currentNavigationController = navigationController
    }
    
    func dismissSearch() {
        
        self.mainNavigationController.dismissViewControllerAnimated(true, completion: nil)
        self.currentNavigationController = self.mainNavigationController
    }
    
    func shareArticle(article: Article) {

        guard let url = self.networking.articleDetailsUrl(articleId: article.id) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.currentViewController.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    private func createArticlesViewModel() -> ArticlesViewModel {
        
        return ArticlesViewModel(settings: self.settings, imageGateway: self.imageCache, articlesFetcher: self.contentProvider, articleDetailsPresenter: self, settingsPresenter: self, searchPresenter: self)
    }
    
    private func createArticleDetailsViewModel(article article: Article) -> ArticleDetailsViewModel {
        
        return ArticleDetailsViewModel(settings: self.settings, article: article, imageGateway: self.imageCache, articleDetailsFetcher: self.contentProvider, favouriteMaker: self.contentProvider, articleDetailsDismisser: self, articleSharer: self, topOffsetEditor: self.contentProvider)
    }
    
    private func createSearchViewModel() -> SearchViewModel {
        
        return SearchViewModel(settings: self.settings, imageGateway: self.imageCache, articleStorage: self.contentProvider, favouriteArticleStorage: self.contentProvider, articleDetailsPresenter: self, dismisser: self)
    }
    
    private func createSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(settings: self.settings, dismisser: self, imageCleaner: self.imageCache, articleCleaner: self.contentProvider)
    }
}
