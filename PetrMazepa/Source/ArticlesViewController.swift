//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView?
    weak var layout: ArticlesViewLayout?
    @IBOutlet weak var searchContainerView: UIView!
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
                
                notNilModel.articlesInserted = { (range: Range<Int>) in
                    
                    let insertedIndexPaths = self.layout!.insertArticles(range.count)
                    
                    if range.startIndex == 0 {
                        self.collectionView!.reloadData()
                    } else {
                        self.collectionView!.insertItemsAtIndexPaths(insertedIndexPaths)
                    }
                }
                
                notNilModel.errorOccurred = { (error: NSError) in

                    UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
                }
                
                notNilModel.loadingStateChanged = { (loading: Bool) in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
                }
                
                notNilModel.searchStateChanged = { (expand: Bool) in
                    
                    self.heightSearchConstraint.constant = expand ? 300.0 : 74.0
                    self.view.layoutIfNeeded()
                }
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
        self.model!.loadIfNeeded()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.articles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let image = self.model!.articles[indexPath.row]
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
}

