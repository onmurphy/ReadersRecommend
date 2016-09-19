//
//  ReviewOptionsTableViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/17/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit

class ReviewOptionsTableViewController: UITableViewController {
    
    let categories = ["Goodreads", "Amazon", "iDreamBooks"]
    
    override func viewDidLoad() {
        tableView.alwaysBounceVertical = false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return tableView.frame.size.height / 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.item == 0 {
            cell.imageView?.image = UIImage(named: "goodreads")
        }
        
        if indexPath.item == 1 {
            cell.imageView?.image = UIImage(named: "amazon")
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if indexPath.item == 2 {
            cell.imageView?.image = UIImage(named: "idreambooks")
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(categories[indexPath.item])
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ReviewsWebViewController") as! ReviewsWebViewController

        self.navigationController!.pushViewController(vc, animated: true)
        
    }
}