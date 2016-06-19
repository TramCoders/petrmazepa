//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow: NSObject, ArticleContentPresenter, SettingsPresenter, SearchPresenter, ArticleContentDismisser, SettingsDismisser, SearchDismisser, ArticleSharer {
    
    private let window: UIWindow
    private let storyboard: UIStoryboard
    
    private var mainNavigationController: UINavigationController
    private var currentNavigationController: UINavigationController
    private var currentViewController: UIViewController
    
    private let imageCache: ImageCache
    private let contentProvider: ContentProvider
    private let networking: Networking
    private let coreData: CoreDataManager
    private let settings: Settings
    private let tracker: Tracker
    
    override init() {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window.tintColor = UIColor(red: 0.933, green: 0.427, blue: 0.439, alpha: 1.0)
        
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mainNavigationController = self.storyboard.instantiateInitialViewController() as! UINavigationController
        self.currentNavigationController = self.mainNavigationController
        self.currentViewController = self.mainNavigationController
        
        self.settings = Settings()
        self.networking = Networking()
        self.coreData = CoreDataManager()
        self.contentProvider = ContentProvider(networking: self.networking, coreData: self.coreData)
        self.tracker = Tracker()
        
        let inMemoryImageStorage = InMemoryImageStorage()
        let persistentImageStorage = PersistentImageStorage()
        self.imageCache = ImageCache(inMemoryImageStorage: inMemoryImageStorage, persistentImageStorage: persistentImageStorage, downloader: self.networking)
        
        super.init()
    }
    
    func start() {
        self.presentArticles()
    }
    
    func save() {
        self.coreData.saveContext()
    }
    
    func presentArticles() {
        
        let articlesViewController = self.currentNavigationController.topViewController as! ArticlesViewController
        articlesViewController.model = self.createArticlesViewModel()

        self.window.rootViewController = self.currentNavigationController
        self.window.makeKeyAndVisible()
        
        self.currentViewController = articlesViewController
    }
    
    func presentArticleContent(forCaption caption: ArticleCaption) {
        
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("Details") as! ArticleDetailsViewController
        viewController.model = self.createArticleContentViewModel(article: caption)
        self.currentNavigationController.pushViewController(viewController, animated: true)
        self.currentViewController = viewController
    }
    
    func dismissArticleContent() {

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
    
    func shareArticle(withCaption caption: ArticleCaption) {

        guard let url = self.networking.articleDetailsUrl(articleId: caption.id) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.currentViewController.presentViewController(activityViewController, animated: true, completion: nil)

        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in

            guard completed && (activityError == nil) else {
                return
            }
            
            Tracker.trackShare(caption, activityType: activityType)
        }
    }
    
    private func createArticlesViewModel() -> ArticlesViewModel {
        
        return ArticlesViewModel(settings: self.settings, articleStorage: self.contentProvider, imageGateway: self.imageCache, articlesFetcher: self.contentProvider, articleContentPresenter: self, settingsPresenter: self, searchPresenter: self)
    }
    
    private func createArticleContentViewModel(article article: ArticleCaption) -> ArticleContentViewModel {
        
        return ArticleContentViewModel(settings: self.settings, article: article, imageGateway: self.imageCache, articleContentFetcher: self.contentProvider, favouriteMaker: self.contentProvider, articleContentDismisser: self, articleSharer: self, topOffsetEditor: self.contentProvider, lastReadArticleMaker: self.contentProvider, tracker: self.tracker)
    }
    
    private func createSearchViewModel() -> SearchViewModel {
        
        return SearchViewModel(settings: self.settings, imageGateway: self.imageCache, articleStorage: self.contentProvider, favouriteArticleStorage: self.contentProvider, articleContentPresenter: self, dismisser: self, tracker: self.tracker)
    }
    
    private func createSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(settings: self.settings, dismisser: self, imageCacheUtil: self.imageCache)
    }
}
