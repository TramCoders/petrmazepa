//
//  SearchViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTableContraint: NSLayoutConstraint!
    
    private var showKeyboardHandler: NSObjectProtocol?
    private var hideKeyboardHandler: NSObjectProtocol?
    
    var model: SearchViewModel? {
        didSet {
            self.model!.articlesChanged = self.articlesChangedHandler()
            self.model!.thumbImageLoaded = self.thumbImageLoadedHandler()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SearchedArticleCell", bundle: nil), forCellReuseIdentifier: "SearchedArticle")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.startHandlingKeyboardAppearance()
        self.view.layoutIfNeeded()
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
        self.stopHandlingKeyboardAppearance()
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.screenFlow!.hideSearch()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.model!.didChangeQuery(searchText)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model!.articlesCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchedArticle", forIndexPath: indexPath) as! SearchedArticleCell
        
        let index = indexPath.row
        let searchedArticle = self.model!.requestArticle(index)
        cell.update(title: searchedArticle.title, author: searchedArticle.author)
        
        let image = self.model!.requestThumb(index)
        cell.updateThumb(image)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 61.0
    }
    
    private func startHandlingKeyboardAppearance() {
        
        self.startHandlingShowKeyboard()
        self.startHandlingHideKeyboard()
    }
    
    private func startHandlingShowKeyboard() {
        
        self.showKeyboardHandler = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { (note: NSNotification) -> Void in
            
            let userInfo = note.userInfo!
            let keyboardScreenEndFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardScreenEndFrame = keyboardScreenEndFrameValue.CGRectValue()
            let keyboardHeight = keyboardScreenEndFrame.height
            
            self.bottomTableContraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func startHandlingHideKeyboard() {
        
        self.hideKeyboardHandler = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { (note: NSNotification) -> Void in
            
            self.bottomTableContraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func stopHandlingKeyboardAppearance() {
        
        self.stopHandlingShowKeyboard()
        self.stopHandlingHideKeyboard()
    }
    
    private func stopHandlingShowKeyboard() {
        
        if let notNilShowKeyboardHandler = self.showKeyboardHandler {
            
            NSNotificationCenter.defaultCenter().removeObserver(notNilShowKeyboardHandler)
            self.showKeyboardHandler = nil
        }
    }
    
    private func stopHandlingHideKeyboard() {
        
        if let notNilHideKeyboardHandler = self.hideKeyboardHandler {
            
            NSNotificationCenter.defaultCenter().removeObserver(notNilHideKeyboardHandler)
            self.hideKeyboardHandler = nil
        }
    }
    
    private func articlesChangedHandler() -> (() -> Void) {
        return {
            self.tableView.reloadData()
        }
    }
    
    private func thumbImageLoadedHandler() -> ((index: Int) -> Void) {
        return { (index: Int) in
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)], withRowAnimation: .Automatic)
        }
    }
}
