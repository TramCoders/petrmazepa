//
//  SearchViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTableContraint: NSLayoutConstraint!
    
    private var showKeyboardHandler: NSObjectProtocol?
    private var hideKeyboardHandler: NSObjectProtocol?
    
    var model: SearchViewModel! {
        didSet {
            self.model.articlesChanged = self.articlesChangedHandler()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SearchedArticleCell", bundle: nil), forCellReuseIdentifier: "SearchedArticle")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.model.viewWillAppear()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.startHandlingKeyboardAppearance()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.stopHandlingKeyboardAppearance()
        self.model.viewWillDisappear()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.model.didChangeQuery(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        self.model.closeTapped()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.model.sectionsCount()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.model.sectionHeadersVisible() ? 40.0 : 0.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard self.model.sectionHeadersVisible() else {
            return nil
        }
        
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: nil, options: nil).first as! HeaderView
        let titleKey = self.model.sectionTitleKey(section: section)
        headerView.text = NSLocalizedString(titleKey, comment: "")
        
        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.articlesCount(section: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SearchedArticle", forIndexPath: indexPath) as! SearchedArticleCell
        let searchedArticle = self.model.searchedArticleModel(indexPath: indexPath)
        cell.model = searchedArticle

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.model.articleTapped(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
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
    
    private func thumbImageLoadedHandler() -> ((indexPath: NSIndexPath) -> Void) {
        return { (indexPath: NSIndexPath) in
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}
