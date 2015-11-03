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
        return .Default
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView.collectionViewLayout as? ArticlesViewLayout
        
        // notify model
        self.model!.viewDidLoad(screenSize: UIScreen.mainScreen().bounds.size)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.articlesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let articleModel = self.model!.requestArticleModel(index: indexPath.item)
        cell.update(articleModel)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.model?.articleTapped(index: indexPath.row)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let distance = scrollView.contentSize.height - scrollView.frame.height - scrollView.contentOffset.y
        self.model!.didChangeDistanceToBottom(distance)
    }
    
    private func articlesInsertedHandler() -> ((range: Range<Int>) -> Void) {

        return { (range: Range<Int>) in
            
            let insertedIndexPaths = self.layout!.insertArticles(range.count)
            
            if range.startIndex == 0 {
                self.collectionView.reloadData()
            } else {
                self.collectionView.insertItemsAtIndexPaths(insertedIndexPaths)
            }
        }
    }
    
    private func thumbImageLoadedHandler() -> ((index: Int) -> Void) {
        return { index in
            self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError?) -> Void) {

        return { _ in
            
            let alertController = UIAlertController(title: nil, message: "Не удалось получить статьи", preferredStyle: .Alert)
            
            let retryAction = UIAlertAction(title: "Ещё раз", style: .Default, handler: { _ in
                self.model!.retryActionTapped()
            })
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .Default, handler: { _ in
                self.model!.cancelActionTapped()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(retryAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func loadingStateChangedHandler() -> ((loading: Bool) -> Void) {
        return { (loading: Bool) in
            // TODO:
        }
    }
    
}

