//
//  ArticleTextCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

protocol ArticleTextCellDelegate: class {
    func articleTextCellDidDetermineHeight(sender cell: ArticleTextCell, height: CGFloat)
}

class ArticleTextCell: UICollectionViewCell, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var heightWebViewConstraint: NSLayoutConstraint!
    
    weak var delegate: ArticleTextCellDelegate?
    
    var text: String? {
        didSet {
            if let notNilText = self.text {

                self.webView.scrollView.scrollEnabled = false
                self.webView.loadHTMLString(notNilText, baseURL: NSURL(string: "http:"))
            }
        }
    }
    
    var height: CGFloat = 0.0 {
        didSet {
            
            self.heightWebViewConstraint.constant = self.height
            self.contentView
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        // TODO: handle
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        self.webView.scrollView.scrollEnabled = true
        let size = webView.sizeThatFits(CGSizeMake(webView.bounds.width, CGFloat.max))
        self.delegate?.articleTextCellDidDetermineHeight(sender: self, height: size.height)
    }
}
