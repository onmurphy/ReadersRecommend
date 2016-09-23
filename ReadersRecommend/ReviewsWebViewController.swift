//
//  ReviewsWebViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/17/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit

class ReviewsWebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var url: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        self.webView.scrollView.bounces = false
        
        url = NSURL (string: "https://www.goodreads.com/api/reviews_widget_iframe?did=DEVELOPER_ID&amp;format=html&amp;isbn=0441172717&amp;links=660&amp;min_rating=&amp;review_back=fff&amp;stars=000&amp;text=000");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
    
    @IBAction func refreshClicked() {
        self.webView.reload()
    }
    
    @IBAction func launchSafariClicked() {
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func returnClicked() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
}