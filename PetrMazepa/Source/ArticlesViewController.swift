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
    private var refreshControl: UIRefreshControl!
    
    weak var layout: ArticlesViewLayout!
    private let cellReuseIdentifier = "ArticleCell"
    
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    
    var model: ArticlesViewModel! {

        didSet {
            
            self.model.articlesInserted = self.articlesInsertedHandler()
            self.model.allArticlesDeleted = self.allArticlesDeletedHandler()
            self.model.refreshingStateChanged = self.refreshingStateChangedHandler()
            self.model.errorOccurred = self.errorOccurredHandler()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // title
        self.title = NSLocalizedString("ArticlesScreenTitle", comment: "")
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView.collectionViewLayout as? ArticlesViewLayout
        
        // refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: Selector("refreshTriggered"), forControlEvents: .ValueChanged)
        self.collectionView.addSubview(self.refreshControl)
        
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
    
    private func allArticlesDeletedHandler() -> (() -> Void) {
        return {
            
            self.layout.deleteAllArticles()
            self.collectionView.reloadData()
        }
    }
    
    private func refreshingStateChangedHandler() -> ((refreshing: Bool) -> Void) {
        return { refreshing in
            
            guard self.refreshControl.refreshing != refreshing else {
                return
            }
            
            if refreshing {
                self.refreshControl.beginRefreshing()
            } else {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError?) -> Void) {

        return { _ in
            
            let alertController = UIAlertController(title: nil, message: "Не удалось получить статьи", preferredStyle: .Alert)
            
            let retryAction = UIAlertAction(title: "Ещё раз", style: .Default, handler: { _ in
                self.model.retryActionTapped()
            })
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .Default, handler: { _ in
                self.model.cancelActionTapped()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(retryAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func indexPaths(range range: Range<Int>) -> [NSIndexPath] {
        return range.map({ NSIndexPath(forItem: $0, inSection: 0) })
    }
}
