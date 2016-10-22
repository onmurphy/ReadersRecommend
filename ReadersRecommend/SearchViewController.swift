//
//  SearchViewController.swift
//  a
//
//  Created by Olivia Murphy on 10/21/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    
    var shouldShowSearchResults = false
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    var results : [[String]] = []

    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        let image = UIImage(named: "logo")
        navigationItem.titleView = UIImageView(image: image)
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.searchController.searchBar.barTintColor = UIColor(red: 45.0/255.0, green: 181.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let searchString = searchController.searchBar.text
        
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
        
        GoogleClient.sharedInstance().searchBook(searchString!) { (result, error) in
            if error == nil {
                self.results = result!
                print(self.results)
                self.animateTable()
            }
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return tableView.frame.size.height / 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        if results.count != 0 {
            let url = NSURL(string: results[indexPath.item][2])
            cell.imageView?.image = UIImage(data: NSData(contentsOfURL:url!)!)
            cell.textLabel?.text = results[indexPath.item][0]
            cell.textLabel?.font = UIFont(name:"North", size:12)
        } else {
            cell.imageView
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        vc.barcode = self.results[indexPath.item][3]
        
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func animateTable() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        
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
