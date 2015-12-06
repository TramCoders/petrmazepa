//
//  ArticleDetailsViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, ArticleTextCellDelegate {
    
    enum DetailsItem: Int {
        
        case Image
        case Text
    }
    
    var model: ArticleDetailsViewModel! {
        didSet {

            self.model.favouriteStateChanged = self.favouriteStateChangedHandler()
            self.model.barsVisibilityChanged = self.barsVisibilityChangedHandler()
            self.model.imageLoaded = self.imageLoadedHandler()
            self.model.textLoaded = self.textLoadedHandler()
            self.model.errorOccurred = self.errorOccurredHandler()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private weak var layout: ArticleDetailsLayout!
    @IBOutlet weak var favouriteButton: UIButton!
    
    private weak var imageCell: ArticleImageCell!
    private weak var textCell: ArticleTextCell!
    
    @IBOutlet weak var heightToolbarConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToolbarConstraint: NSLayoutConstraint!
    
    private var startOffsetY: CGFloat = 0.0
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .None
        
        // layout
        self.layout = self.collectionView.collectionViewLayout as! ArticleDetailsLayout
        
        // register cells
        self.collectionView.registerNib(UINib(nibName: "ArticleImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.collectionView.registerNib(UINib(nibName: "ArticleTextCell", bundle: nil), forCellWithReuseIdentifier: "TextCell")
    }
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        self.model.viewDidLayoutSubviews(screenSize: UIScreen.mainScreen().bounds.size)
        self.layoutBars()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.model.viewWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.model.viewWillDisappear()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.model.viewDidAppear()
    }
    
    @IBAction func backTapped(sender: AnyObject) {
        self.model.backTapped()
    }
    
    @IBAction func favouriteTapped(sender: UIButton) {
        self.model.favouriteTapped()
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        self.model.shareTapped()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch self.convertItem(indexPath.item) {
            
            case .Image:
                
                self.imageCell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ArticleImageCell
                self.imageCell.image = self.model.image
                return self.imageCell
            
            case .Text:
                
                self.textCell = collectionView.dequeueReusableCellWithReuseIdentifier("TextCell", forIndexPath: indexPath) as! ArticleTextCell
                self.textCell.delegate = self
                self.textCell.text = self.model.htmlText
                return self.textCell
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.model.scrollViewWillBeginDragging(offset: scrollView.contentOffset.y);
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.model.scrollViewWillEndDragging(offset: scrollView.contentOffset.y)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func articleTextCellDidDetermineHeight(sender cell: ArticleTextCell, height: CGFloat) {
        
        self.layout.textCellHeight = height
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func layoutBars() {
        
        self.bottomToolbarConstraint.constant = self.model.barsVisibile ? 0.0 : -self.heightToolbarConstraint.constant
        self.view.layoutIfNeeded()
    }
    
    private func convertItem(item: Int) -> DetailsItem {
        return DetailsItem(rawValue: item)!
    }
    
    private func loadingStateChangedHandler() -> ((loading: Bool) -> Void) {
        return { loading in
            // TODO:
        }
    }
    
    private func favouriteStateChangedHandler() -> ((favourite: Bool) -> Void) {
        return { favourite in
            
            let image = favourite ? UIImage(named: "favourite_icon") : UIImage(named: "unfavourite_icon")
            self.favouriteButton.setImage(image, forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.favouriteButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { _ in
                self.favouriteButton.transform = CGAffineTransformIdentity
            })
        }
    }
    
    private func barsVisibilityChangedHandler() -> ((visible: Bool) -> Void) {
        return { _ in
            UIView.animateWithDuration(0.3, animations: {
                self.layoutBars()
            })
        }
    }
    
    private func imageLoadedHandler() -> ((image: UIImage?) -> Void) {
        return { image in
            self.imageCell.image = image
        }
    }
    
    private func textLoadedHandler() -> ((htmlText: String?) -> Void) {
        return { htmlText in
            self.textCell.text = htmlText
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError?) -> Void) {
        return { _ in
            
            let alertController = UIAlertController(title: nil, message: "При получении статьи произошла ошибка", preferredStyle: .Alert)
            
            let closeAction = UIAlertAction(title: "Закрыть", style: .Cancel, handler: { _ in
                self.model.closeActionTapped()
            })
            
            let retryAction = UIAlertAction(title: "Ещё раз", style: .Default, handler: { _ in
                self.model.retryActionTapped()
            })
            
            alertController.addAction(closeAction)
            alertController.addAction(retryAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
