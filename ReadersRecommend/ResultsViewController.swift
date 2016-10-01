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
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var recommendButton: UIButton!
    
    var barcode: String?
    var stack: CoreDataStack!
    var data: NSData!
    
    override func viewDidLoad() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.stack = delegate.stack
        
        self.coverActivity.startAnimating()
        self.checkReviewsButton.enabled = false
        self.addToListButton.enabled = false
        self.recommendButton.enabled = false
        
        self.cover.layer.shadowColor = UIColor.blackColor().CGColor
        self.cover.layer.shadowOffset = CGSizeMake(3, 3)
        self.cover.layer.shadowRadius = 6
        self.cover.layer.shadowOpacity = 0.5
        
        self.checkReviewsButton.layer.cornerRadius = 5
        self.checkReviewsButton.alpha = 0.5
        self.checkReviewsButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.checkReviewsButton.layer.shadowOffset = CGSizeMake(3, 3)
        self.checkReviewsButton.layer.shadowRadius = 3
        self.checkReviewsButton.layer.shadowOpacity = 0.5
        
        self.addToListButton.layer.cornerRadius = 5
        self.addToListButton.alpha = 0.5
        self.addToListButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.addToListButton.layer.shadowOffset = CGSizeMake(3, 3)
        self.addToListButton.layer.shadowRadius = 3
        self.addToListButton.layer.shadowOpacity = 0.5
        
        self.recommendButton.layer.cornerRadius = 5
        self.recommendButton.alpha = 0.5
        self.recommendButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.recommendButton.layer.shadowOffset = CGSizeMake(3, 3)
        self.recommendButton.layer.shadowRadius = 3
        self.recommendButton.layer.shadowOpacity = 0.5
        
        GoogleClient.sharedInstance().getBookInfo(barcode!) { (result, error) in
            print (result)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.bookTitle.text = result![0] as? String
                self.authors.text = result![1] as? String
                
                let url = NSURL(string: result![2] as! String)
                self.data = NSData(contentsOfURL: url!)
                self.cover.image = UIImage(data: self.data!)
                
                self.coverActivity.stopAnimating()
                self.coverActivity.hidden = true
                self.checkReviewsButton.enabled = true
                self.addToListButton.enabled = true
                self.recommendButton.enabled = true
                self.checkReviewsButton.alpha = 1.0
                self.addToListButton.alpha = 1.0
                self.recommendButton.alpha = 1.0
            }
        }
    }
    
    @IBAction func loveBook() {
        let book = Book(title: self.bookTitle.text!, isbn: self.barcode!, authors: self.authors.text!, image: self.data, context: self.stack.context)
        print("added")
        do{
            try self.stack.context.save()
        }catch{
            fatalError("Error while saving main context: \(error)")
        }
    }
    
    @IBAction func checkReviewsClicked() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ReviewOptionsTableViewController") as! ReviewOptionsTableViewController
        vc.barcode = self.barcode
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
