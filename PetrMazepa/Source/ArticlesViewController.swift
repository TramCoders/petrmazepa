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
    private let cellReuseIdentifier = "ArticleCell"
    
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    
    var model: ArticlesViewModel! {

        didSet {
            
            self.model.articlesInserted = self.articlesInsertedHandler()
            self.model.errorOccurred = self.errorOccurredHandler()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = NSLocalizedString("ArticlesScreenTitle", comment: "")
        
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
            
            let insertedIndexPaths = self.layout!.insertArticles(range.count)
            
            if range.startIndex == 0 {
                self.collectionView.reloadData()
            } else {
                self.collectionView.insertItemsAtIndexPaths(insertedIndexPaths)
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
}
