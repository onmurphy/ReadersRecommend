//
//  LoveViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/18/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoveTableViewController: UITableViewController {

    var stack: CoreDataStack!
    
    var appDelegate: AppDelegate!

    var books = [Book]()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Must Reads!"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        books.removeAll()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
        
        let fr = NSFetchRequest(entityName: "Book")
        
        do {
            let result = try self.stack.context.executeFetchRequest(fr)
            
            for managedObject in result {
                books.append(managedObject as! Book)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        animateTable()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return tableView.frame.size.height / 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.imageView?.image = UIImage(data: books[indexPath.item].image!)
        cell.textLabel?.text = books[indexPath.item].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print(categories[indexPath.item])
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        vc.barcode = books[indexPath.item].isbn
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.stack.context.deleteObject(books[indexPath.item])
            books.removeAtIndex(indexPath.item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
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