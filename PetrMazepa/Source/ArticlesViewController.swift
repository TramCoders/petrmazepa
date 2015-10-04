//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var layout: ArticlesViewLayout!
    let cellReuseIdentifier = "ArticleCell"
    
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    
    var model: ArticlesViewModel? {

        didSet {
            
            self.model!.articlesInserted = self.articlesInsertedHandler()
            self.model!.thumbImageLoaded = self.thumbImageLoadedHandler()
            self.model!.errorOccurred = self.errorOccurredHandler()
            self.model!.loadingStateChanged = self.loadingStateChangedHandler()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView!.collectionViewLayout as? ArticlesViewLayout
        
        // notify model
        self.model!.viewDidLoad()
    }
    
    @IBAction func searchTapped(sender: AnyObject) {
        self.screenFlow!.showSearch()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.articlesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let thumb = self.model!.requestThumb(index: indexPath.item)
        print("thumb for \(indexPath.row): \(thumb)")
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
    
}

