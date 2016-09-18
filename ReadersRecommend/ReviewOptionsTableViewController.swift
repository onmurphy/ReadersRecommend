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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = categories[indexPath.item]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(categories[indexPath.item])
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ReviewsWebViewController") as! ReviewsWebViewController

        self.navigationController!.pushViewController(vc, animated: true)
        
    }
}