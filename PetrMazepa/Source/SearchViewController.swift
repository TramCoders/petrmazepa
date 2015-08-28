//
//  SearchViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    private var showKeyboardHandler: NSObjectProtocol?
    private var hideKeyboardHandler: NSObjectProtocol?
    
    var model: SearchViewModel? {
        didSet {
            // TODO: implement
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.showKeyboardHandler = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { (note: NSNotification) -> Void in
            
            let keyboardScreenEndFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let keyboardHeight = keyboardScreenEndFrame.height
            
            self.model!.keyboardWillAppear(height: keyboardHeight)
        }
        
        self.hideKeyboardHandler = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { (note: NSNotification) -> Void in
            
            self.model!.keyboardWillDisappear()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        if let notNilShowKeyboardHandler = self.showKeyboardHandler {
         
            NSNotificationCenter.defaultCenter().removeObserver(notNilShowKeyboardHandler)
            self.showKeyboardHandler = nil
        }
        
        if let notNilHideKeyboardHandler = self.hideKeyboardHandler {
            
            NSNotificationCenter.defaultCenter().removeObserver(notNilHideKeyboardHandler)
            self.hideKeyboardHandler = nil
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCellWithIdentifier("Article", forIndexPath: indexPath)
    }
}