//
//  ResultsViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/16/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var coverActivity: UIActivityIndicatorView!
    @IBOutlet weak var checkReviewsButton: UIButton!
    @IBOutlet weak var loveButton: UIButton!
    
    var barcode: String?
    var stack: CoreDataStack!
    
    override func viewDidLoad() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.stack = delegate.stack
        
        self.coverActivity.startAnimating()
        self.checkReviewsButton.enabled = false
        self.checkReviewsButton.alpha = 0.5
        self.checkReviewsButton.layer.cornerRadius = 6
        self.checkReviewsButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.checkReviewsButton.layer.shadowOffset = CGSizeMake(3, 3)
        self.checkReviewsButton.layer.shadowRadius = 3
        self.checkReviewsButton.layer.shadowOpacity = 0.5
        self.view.bringSubviewToFront(loveButton)
        
        GoogleClient.sharedInstance().getBookInfo(barcode!) { (result, error) in
            print (result)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.bookTitle.text = result![0] as? String
                self.authors.text = result![1] as? String
                
                let url = NSURL(string: result![2] as! String)
                let data = NSData(contentsOfURL: url!)
                self.cover.image = UIImage(data: data!)
                
                self.coverActivity.stopAnimating()
                self.coverActivity.hidden = true
                self.checkReviewsButton.enabled = true
                self.checkReviewsButton.alpha = 1.0
            }
        }
    }
    
    //do{
    //try self.stack.context.save()
    //}catch{
    //fatalError("Error while saving main context: \(error)")
    //}
}