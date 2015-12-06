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
    weak var delegate: ArticleTextCellDelegate?
    
    var text: String? {
        didSet {
            if let notNilText = self.text {
                self.webView.loadHTMLString(notNilText, baseURL: NSURL(string: "http:"))
            }
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        // TODO: handle
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let size = webView.sizeThatFits(CGSizeMake(webView.bounds.width, CGFloat.max))
        self.delegate?.articleTextCellDidDetermineHeight(sender: self, height: size.height)
    }
}
