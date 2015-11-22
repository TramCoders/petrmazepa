//
//  SearchViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
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
        
        // register cell
        self.tableView.registerNib(UINib(nibName: "SearchedArticleCell", bundle: nil), forCellReuseIdentifier: "SearchedArticle")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.model.viewWillAppear()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.startHandlingKeyboardAppearance()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.searchTextField.resignFirstResponder()
        self.stopHandlingKeyboardAppearance()
        self.model.viewWillDisappear()
    }
    
    @IBAction func searchDidChange(sender: UITextField) {
        
        if let searchText = sender.text {
            self.model.didChangeQuery(searchText)
        } else {
            self.model.didChangeQuery("")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: nil, options: nil).first as? HeaderView else {
            return nil
        }

        if section == 0 {
            headerView.text = "Favourite"
        } else {
            headerView.text = "Other"
        }
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.searchTextField.resignFirstResponder()
        return false
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
            
            self.bottomTableContraint.constant = keyboardHeight - 49.0
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
