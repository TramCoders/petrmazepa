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
    @IBOutlet weak var lastReadArticleView: LastReadArticleView!
    
    @IBOutlet weak var bottomLastReadConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLastReadConstraint: NSLayoutConstraint!
    
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
            self.model.lastReadArticleVisibleChanged = self.lastReadArticleVisibleChangedHandler()
            self.model.navigationBarVisibleChanged = self.navigationBarVisibleChangedHandler()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
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
        self.model.viewWillAppear()

        // last read article model
        self.lastReadArticleView.model = self.model.lastReadArticleViewModel
        
        // navigation bar visibility
        self.navigationController?.setNavigationBarHidden(!self.model.navigationBarVisible, animated: true)
        
        // last read article visibility
        self.bottomLastReadConstraint.constant = self.model.lastReadArticleVisible ? 0.0 : -self.heightLastReadConstraint.constant
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.model.viewWillDisappear()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return !self.model.navigationBarVisible
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
    
    @IBAction func lastReadArticleTapped(sender: AnyObject) {
        self.model.lastReadArticleTapped()
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
        
        let contentOffset = scrollView.contentOffset.y
        let distance = scrollView.contentSize.height - scrollView.frame.height - contentOffset
        self.model.didScroll(contentOffset: contentOffset, distanceToBottom: distance)
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
    
    private func lastReadArticleVisibleChangedHandler() -> ((visible: Bool, animated: Bool) -> Void) {
        return { visible, animated in

            self.bottomLastReadConstraint.constant = visible ? 0.0 : -self.heightLastReadConstraint.constant
            
            if animated {
                UIView.animateWithDuration(0.1, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func navigationBarVisibleChangedHandler() -> ((visible: Bool, animated: Bool) -> Void) {
        return { visible, animated in

            self.navigationController?.setNavigationBarHidden(!visible, animated: animated)
            self.setNeedsStatusBarAppearanceUpdate()
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
