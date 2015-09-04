//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var layout: ArticlesViewLayout!
    let cellReuseIdentifier = "ArticleCell"
    
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    
    var searchViewController: UIViewController? {
        didSet {
            self.addChildViewController(self.searchViewController!)
        }
    }
    
    var model: ArticlesViewModel? {

        didSet {
            
            if let notNilModel = self.model {
                
                notNilModel.searchStateChanged = self.searchStateChangedHandler();
                notNilModel.articlesInserted = self.articlesInsertedHandler()
                notNilModel.thumbImageLoaded = self.thumbImageLoadedHandler()
                notNilModel.errorOccurred = self.errorOccurredHandler()
                notNilModel.loadingStateChanged = self.loadingStateChangedHandler()
            }
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // search
        if let notNilSearchViewController = self.searchViewController {
            
            self.searchContainerView.addSubview(notNilSearchViewController.view)
            
            let searchView = notNilSearchViewController.view
            
            searchView.translatesAutoresizingMaskIntoConstraints = false
            
            
            let leftConstraint = NSLayoutConstraint(item: searchView, attribute:
                .Leading, relatedBy: .Equal, toItem: self.searchContainerView,
                attribute: .Leading, multiplier: 1.0,
                constant: 0.0)
            
            let topConstraint = NSLayoutConstraint(item: searchView, attribute:
                .Top, relatedBy: .Equal, toItem: self.searchContainerView,
                attribute: .Top, multiplier: 1.0,
                constant: 0.0)
            
            let rightConstraint = NSLayoutConstraint(item: searchView, attribute:
                .Trailing, relatedBy: .Equal, toItem: self.searchContainerView,
                attribute: .Trailing, multiplier: 1.0,
                constant: 0.0)
            
            let bottomConstraint = NSLayoutConstraint(item: searchView, attribute:
                .Bottom, relatedBy: .Equal, toItem: self.searchContainerView,
                attribute: .Bottom, multiplier: 1.0,
                constant: 0.0)
            
            self.searchContainerView.addConstraints([leftConstraint, topConstraint, rightConstraint, bottomConstraint])

            
            
            
            notNilSearchViewController.didMoveToParentViewController(self)
        }
        
        
        
        
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView!.collectionViewLayout as? ArticlesViewLayout
        
        // notify model
        self.model!.viewDidLoad()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.articlesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let thumb = self.model!.requestThumb(indexPath.item)
        cell.update(thumb)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let beyondBottom = scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentSize.height
        
        if beyondBottom >= 0 {
            self.model!.didScrollToBottom()
        }
    }
    
    private func articlesInsertedHandler() -> ((range: Range<Int>) -> Void) {

        return { (range: Range<Int>) in
            
            let insertedIndexPaths = self.layout!.insertArticles(range.count)
            
            if range.startIndex == 0 {
                self.collectionView!.reloadData()
            } else {
                self.collectionView!.insertItemsAtIndexPaths(insertedIndexPaths)
            }
        }
    }
    
    private func thumbImageLoadedHandler() -> ((index: Int) -> Void) {
        return { (index: Int) in
            self.collectionView!.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError) -> Void) {

        return { (error: NSError) in
            
            let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func loadingStateChangedHandler() -> ((loading: Bool) -> Void) {
        return { (loading: Bool) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
        }
    }
    
    private func searchStateChangedHandler() -> ((expanded: Bool, keyboardHeight: CGFloat) -> Void) {

        return { (expanded: Bool, keyboardHeight: CGFloat) in
            
            self.heightSearchConstraint.constant = expanded ? (self.view.frame.height - keyboardHeight) : 74.0
            self.view.layoutIfNeeded()
        }
    }
}

