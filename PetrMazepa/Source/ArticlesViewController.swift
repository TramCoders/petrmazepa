//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var model: ArticlesViewModelProtocol!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noArticlesView: UIView!
    @IBOutlet weak var lastReadArticleView: LastReadArticleView!
    
    @IBOutlet weak var bottomLastReadConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLastReadConstraint: NSLayoutConstraint!
    
    weak var layout: ArticlesViewLayout!
    private let cellReuseIdentifier = "ArticleCell"
    private let loadingCellReuseIdentifier = "LoadingCell"
    
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    
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
        return false
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
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.model.willBeginDragging(offset: scrollView.contentOffset.y);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        let distance = scrollView.contentSize.height - scrollView.frame.height - contentOffset
        self.model.didScroll(contentOffset: contentOffset, distanceToBottom: distance)
    }
    
    private func indexPaths(range range: Range<Int>) -> [NSIndexPath] {
        return range.map({ NSIndexPath(forItem: $0, inSection: 0) })
    }
}

extension ArticlesViewController: ArticlesViewProtocol {
    
    func loadingInOfflineModeFailed() {
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
    
    func errorOccurred() {
        
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
    
    func navigationBarVisibilityChanged(visible visible: Bool, animated: Bool) {
        self.navigationController?.setNavigationBarHidden(!visible, animated: animated)
    }
    
    func lastReadArticleVisibilityChanged(visible visible: Bool, animated: Bool) {
        
        self.bottomLastReadConstraint.constant = visible ? 0.0 : -self.heightLastReadConstraint.constant
        
        if animated {
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    func articlesInserted(range range: Range<Int>) {
        
        self.layout.insertArticles(range.count)
        let insertedIndexPaths = self.indexPaths(range: range)
        
        if range.startIndex == 0 {
            self.collectionView.reloadData()
        } else {
            self.collectionView.insertItemsAtIndexPaths(insertedIndexPaths)
        }
    }
    
    func articlesUpdated(newCount newCount: Int) {
        
        self.layout.deleteAllArticles()
        self.layout.insertArticles(newCount)
        self.collectionView.reloadData()
    }
    
    func allArticlesDeleted() {
        
        self.layout.deleteAllArticles()
        self.collectionView.reloadData()
    }
    
    func refreshingStateChanged(refreshing refreshing: Bool) {
        // TODO:
    }
    
    func loadingMoreStateChanged(loadingMore loadingMore: Bool) {
        // TODO:
    }
    
    func noArticlesVisibilityChanged(visible visible: Bool) {
        
        self.collectionView.hidden = visible
        self.noArticlesView.hidden = !visible
    }
}
