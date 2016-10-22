//
//  ResultsViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/16/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SafariServices

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
    var book: Book!
    
    override func viewDidLoad() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.stack = delegate.stack
        
        self.coverActivity.hidden = false
        self.coverActivity.startAnimating()
        self.checkReviewsButton.enabled = false
        self.addToListButton.enabled = false
        self.recommendButton.enabled = false
        
        let image = UIImage(named: "logo")
        navigationItem.titleView = UIImageView(image: image)
        
        self.cover.layer.shadowColor = UIColor.blackColor().CGColor
        self.cover.layer.shadowOffset = CGSizeMake(3, 3)
        self.cover.layer.shadowRadius = 6
        self.cover.layer.shadowOpacity = 0.8
        
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
        
        if book != nil {
            self.addToListButton.setTitle("Remove from Must Read List", forState: .Normal)
            self.bookTitle.text = book.title
            self.authors.text = book.authors
            self.cover.image = UIImage(data: book.image!)
            self.data = book.image!
            self.barcode = book.isbn
            self.enableControls()

        } else {
            GoogleClient.sharedInstance().getBookInfo(barcode!) { (result, error) in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.bookTitle.text = result![0] as? String
                        self.authors.text = result![1] as? String
                        
                        let url = NSURL(string: result![2] as! String)
                        self.data = NSData(contentsOfURL: url!)
                        self.cover.image = UIImage(data: self.data!)
                        
                        self.enableControls()
                    }
                }
                else {
                    let alertController = UIAlertController(title: "Scanning Error", message: "Could not retrieve book info. Please check network connection, or try another book", preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loveBook() {
        if self.addToListButton.currentTitle == "Add to Must Read List" {

            let fetchRequest = NSFetchRequest(entityName: "Book")
            
            let predicate = NSPredicate(format: "isbn == " + self.barcode!)
            fetchRequest.predicate = predicate
            
            do {
                let fetchResults = try self.stack.context.executeFetchRequest(fetchRequest) as? [Book]
                
                if fetchResults!.count > 0 {
                } else {
                    _ = Book(title: self.bookTitle.text!, isbn: self.barcode!, authors: self.authors.text!, image: self.data!, context: self.stack.context)
                    
                    print("added")
                    do{
                        try self.stack.context.save()
                    }catch{
                        fatalError("Error while saving main context: \(error)")
                    }
                }
            } catch {
                fatalError("Error while saving main context: \(error)")
            }
            
            if let badgeValue = tabBarController?.tabBar.items?.first?.badgeValue,
                nextValue = Int(badgeValue)?.successor() {
                tabBarController?.tabBar.items?.first?.badgeValue = String(nextValue)
            } else {
                tabBarController?.tabBar.items?.first?.badgeValue = "1"
            }
            
            self.addToListButton.setTitle("Remove from Must Read List", forState: .Normal)
            
        } else if self.addToListButton.currentTitle == "Remove from Must Read List" {
            self.stack.context.deleteObject(book)
            
            print ("deleted")
            self.addToListButton.setTitle("Add to Must Read List", forState: .Normal)
            
            if let badgeValue = tabBarController?.tabBar.items?.first?.badgeValue {
                let nextValue = Int(badgeValue)! - 1
                
                tabBarController?.tabBar.items?.first?.badgeValue = String(nextValue)
                
                if nextValue == 0 {
                    tabBarController?.tabBar.items?.first?.badgeValue = nil
                }
            }
        }
    }
    
    @IBAction func checkReviewsClicked() {
        
        let url = GoodReadsConstants.Constants.urlPart1 + self.barcode! + GoodReadsConstants.Constants.urlPart2
        
        let svc = SFSafariViewController(URL: NSURL(string: url)!)
        if #available(iOS 10.0, *) {
            svc.preferredBarTintColor = UIColor(red: 49.0/255.0, green: 48.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        } else {
            svc.view.tintColor = UIColor(red: 49.0/255.0, green: 48.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        }
        
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    @IBAction func shareBook() {
        var shareContent = [AnyObject]()
        
        shareContent.append("You have to read this book! \n\n" + self.bookTitle.text! + ", " + self.authors.text!)
        shareContent.append(self.cover.image!)
    
        let activityViewController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePostToTwitter, UIActivityTypeAssignToContact, UIActivityTypeOpenInIBooks, UIActivityTypeSaveToCameraRoll, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint]
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    func enableControls() {
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
