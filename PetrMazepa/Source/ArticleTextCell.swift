//
//  ArticleTextCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

protocol ArticleTextCellDelegate {
    func articleTextCellDidDetermineHeight(sender cell: ArticleTextCell, height: CGFloat)
}

class ArticleTextCell: UICollectionViewCell, ArticleComponentCell, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    private var delegate: ArticleTextCellDelegate?  // FIXME: weak?
    
    func update(value: AnyObject?) {
        
        guard let notNilValue = value as? ArticleTextValue else {
            return
        }
        
        self.delegate = notNilValue.delegate
        
        if let notNilText = notNilValue.text {
            self.webView.loadHTMLString(notNilText, baseURL: NSURL(string: "http:"))
            
        } else {
            self.webView.loadHTMLString("", baseURL: nil)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        // TODO: handle
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        guard let notNilDelegate = self.delegate else {
            return
        }
        
        let size = webView.sizeThatFits(CGSizeMake(webView.bounds.width, CGFloat.max))
        notNilDelegate.articleTextCellDidDetermineHeight(sender: self, height: size.height)
    }
}
