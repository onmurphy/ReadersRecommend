//
//  ReviewOptionsTableViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/17/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class ReviewOptionsTableViewController: UITableViewController {
    
    let categories = ["Goodreads", "iDreamBooks"]
    
    var url : String!
    
    var barcode: String!
    
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.hidden = false
        
        animateTable()
        
        tableView.alwaysBounceVertical = false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return tableView.frame.size.height / 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.item == 0 {
            cell.imageView?.image = UIImage(named: "goodreads")
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if indexPath.item == 1 {
            cell.imageView?.image = UIImage(named: "idreambooks")
            cell.backgroundColor = UIColor.whiteColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(categories[indexPath.item])
        
        if indexPath.item == 0 {
            self.url = "https://www.goodreads.com/api/reviews_widget_iframe?did=u1n5vmgviDEWGU4aa5nu6Q&amp;format=html&amp;isbn=" + self.barcode + "&amp;links=660&amp;min_rating=&amp;review_back=fff&amp;stars=000&amp;text=000"
        }
        
        if indexPath.item == 1 {
            self.url = "https://idreambooks.com/api/books/reviews_widget.js?api_key=66b544b1a6c4ec96c5a80aaa63c93b4c2b0b76c7&isbn=" + self.barcode
            print(self.url)
        }
        let svc = SFSafariViewController(URL: NSURL(string: self.url)!)
        if #available(iOS 10.0, *) {
            svc.preferredBarTintColor = UIColor(red: 183.0/255.0, green: 206.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        } else {
            svc.view.tintColor = UIColor(red: 183.0/255.0, green: 206.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        }
        self.presentViewController(svc, animated: true, completion: nil)
        
    }
    
    func animateTable() {
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

}
