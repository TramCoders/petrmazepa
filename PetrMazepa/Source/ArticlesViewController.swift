//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noArticlesView: UIView!
    
    weak var layout: ArticlesViewLayout!
    private let cellReuseIdentifier = "ArticleCell"
    private let loadingCellReuseIdentifier = "LoadingCell"
    
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    
    var model: ArticlesViewModel! {

        didSet {
            
            self.model.articlesInserted = self.articlesInsertedHandler()
            self.model.articlesUpdated = self.articlesUpdatedHandler()
            self.model.allArticlesDeleted = self.allArticlesDeletedHandler()
            self.model.refreshingStateChanged = self.refreshingStateChangedHandler()
            self.model.loadingMoreStateChanged = self.loadingMoreStateChangedHandler()
            self.model.errorOccurred = self.errorOccurredHandler()
            self.model.loadingInOfflineModeFailed = self.loadingInOfflineModeFailedHandler()
            self.model.noArticlesVisibleChanged = self.noArticlesVisibleChangedHandler()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // title
        self.title = NSLocalizedString("ArticlesScreen_title", comment: "")
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView.collectionViewLayout as? ArticlesViewLayout
        
        // notify model
        self.model.viewDidLoad(screenSize: UIScreen.mainScreen().bounds.size)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.model.viewWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.model.viewWillDisappear()
    }
    
    @IBAction func settingsTapped(sender: AnyObject) {
        self.model.settingsTapped()
    }
    
    @IBAction func searchTapped(sender: AnyObject) {
        self.model.searchTapped()
    }
    
    @IBAction func refreshTapped(sender: AnyObject) {
        self.model.refreshTriggered()
    }
    
    func refreshTriggered() {
        self.model.refreshTriggered()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.articlesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let articleModel = self.model.articleModel(index: indexPath.item)
        cell.model = articleModel
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.model.articleTapped(index: indexPath.row)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let distance = scrollView.contentSize.height - scrollView.frame.height - scrollView.contentOffset.y
        self.model.didChangeDistanceToBottom(distance)
    }
    
    private func articlesInsertedHandler() -> ((range: Range<Int>) -> Void) {

        return { range in
            
            self.layout.insertArticles(range.count)
            let insertedIndexPaths = self.indexPaths(range: range)
            
            if range.startIndex == 0 {
                self.collectionView.reloadData()
            } else {
                self.collectionView.insertItemsAtIndexPaths(insertedIndexPaths)
            }
        }
    }
    
    private func articlesUpdatedHandler() -> ((newCount: Int) -> Void) {
        return { newCount in

            self.layout.deleteAllArticles()
            self.layout.insertArticles(newCount)
            self.collectionView.reloadData()
        }
    }
    
    private func allArticlesDeletedHandler() -> (() -> Void) {
        return {
            
            self.layout.deleteAllArticles()
            self.collectionView.reloadData()
        }
    }
    
    private func refreshingStateChangedHandler() -> ((refreshing: Bool) -> Void) {
        return { refreshing in
            // TODO:
        }
    }
    
    private func loadingMoreStateChangedHandler() -> ((loadingMore: Bool) -> Void) {
        return { loadingMore in
            // TODO:
        }
    }
    
    private func noArticlesVisibleChangedHandler() -> ((visible: Bool) -> Void) {
        return { visible in
            
            self.collectionView.hidden = visible
            self.noArticlesView.hidden = !visible
        }
    }
    
    private func errorOccurredHandler() -> (() -> Void) {
        return {
            
            // message
            let message = NSLocalizedString("ArticlesLoadingFailed_message", comment: "")
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            
            // retry
            let retry = NSLocalizedString("Retry", comment: "")
            
            let retryAction = UIAlertAction(title: retry, style: .Default, handler: { _ in
                self.model.retryActionTapped()
            })
            
            // cancel
            let cancel = NSLocalizedString("Cancel", comment: "")
            
            let cancelAction = UIAlertAction(title: cancel, style: .Default, handler: { _ in
                self.model.cancelActionTapped()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(retryAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func loadingInOfflineModeFailedHandler() -> (() -> Void)? {
        return {
            
            // message
            let message = NSLocalizedString("ArticlesOfflineLoadingFailed_message", comment: "")
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            
            // retry
            let switchOff = NSLocalizedString("SwitchOff", comment: "")
            
            let switchOffAction = UIAlertAction(title: switchOff, style: .Default, handler: { _ in
                self.model.switchOffActionTapped()
            })
            
            // cancel
            let cancel = NSLocalizedString("Cancel", comment: "")
            
            let cancelAction = UIAlertAction(title: cancel, style: .Default, handler: { _ in
                self.model.cancelActionTapped()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(switchOffAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func indexPaths(range range: Range<Int>) -> [NSIndexPath] {
        return range.map({ NSIndexPath(forItem: $0, inSection: 0) })
    }
}
