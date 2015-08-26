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
    weak var layout: ArticlesViewLayout!
    @IBOutlet weak var searchTextField: UITextField!
    let cellReuseIdentifier = "ArticleCell"
    
    var model: ArticlesViewModel? {
        
        didSet {
            
            if let notNilModel = self.model {
                
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
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView!.collectionViewLayout as? ArticlesViewLayout
        self.model!.loadIfNeeded()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.articlesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let image = self.model?.getOrLoadThumb(indexPath.item)
        cell.update(image)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard let notNilModel = self.model else {
            return
        }
        
        guard notNilModel.loading == false else {
            return
        }
        
        let beyondBottom = scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentSize.height
        
        if beyondBottom >= 0 {
            notNilModel.loadMore()
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
            UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
        }
    }
    
    private func loadingStateChangedHandler() -> ((loading: Bool) -> Void) {
        return { (loading: Bool) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
        }
    }
}

