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
    
    var model: ArticleDetailsViewModelProtocol!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private weak var layout: ArticleDetailsLayout!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var statusBarView: UIView!
    private weak var imageCell: ArticleImageCell!
    private weak var textCell: ArticleTextCell!
    
    @IBOutlet weak var heightToolBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToolBarConstraint: NSLayoutConstraint!
    
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
        self.updateBars()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.model.viewWillAppear()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.applicationWillResignActive), name:UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.model.viewWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.model.viewDidAppear()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return !self.model.barsVisibile
    }
    
    func applicationWillResignActive() {
        self.model.applicationWillResignActive()
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.model.scrollViewDidScroll(offset: scrollView.contentOffset.y, contentHeight: scrollView.contentSize.height)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func articleTextCellDidLoad(sender cell: ArticleTextCell, height: CGFloat) {
        
        self.layout.textCellHeight = height
        self.textCell.height = height
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.collectionView.setContentOffset(CGPointMake(0.0, self.model.topOffset), animated: true)
            self.model.textDidLoad()
        }
    }
    
    func articleTextCellDidTapLink(sender cell: ArticleTextCell, url: NSURL?) {
        
        if let url = url {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    private func updateBars() {
        
        self.bottomToolBarConstraint.constant = self.model.barsVisibile ? 0.0 : -self.heightToolBarConstraint.constant
        self.statusBarView.alpha = self.model.barsVisibile ? 1.0 : 0.0
        self.view.layoutIfNeeded()
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func convertItem(item: Int) -> DetailsItem {
        return DetailsItem(rawValue: item)!
    }
}

extension ArticleDetailsViewController: ArticleDetailsViewProtocol {
    
    func reloadImage() {
        self.imageCell.image = self.model.image
    }
    
    func reloadHtmlText() {
        self.textCell.text = self.model.htmlText
    }
    
    func updateFavouriteState(favourite: Bool) {
        
        let image = favourite ? UIImage(named: "favourite_icon") : UIImage(named: "unfavourite_icon")
        self.favouriteButton.setImage(image, forState: UIControlState.Normal)
    }
    
    func updateBarsVisibility(visible: Bool) {
        
        UIView.animateWithDuration(0.2, animations: {
            self.updateBars()
        })
    }
 
    func showError(error: NSError?) {
        
        let alertController = UIAlertController(title: nil, message: "При получении статьи произошла ошибка", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel, handler: { _ in
            self.model.cancelActionTapped()
        })
        
        let retryAction = UIAlertAction(title: "Ещё раз", style: .Default, handler: { _ in
            self.model.retryActionTapped()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
