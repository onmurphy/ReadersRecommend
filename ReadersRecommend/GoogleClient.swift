//
//  GoogleClient.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/16/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation

class GoogleClient {
    func getBookInfo(isbn: String, completionHandlerForBookInfo: (result: [AnyObject]?, error: String?) -> Void) {
        let url = "https://www.googleapis.com/books/v1/volumes?q=ISBN:" + isbn
        let requestURL: NSURL = NSURL(string: url)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(requestURL) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForBookInfo(result: nil, error: "Could not parse data")
                return
            }
            
            guard let data = data else {
                completionHandlerForBookInfo(result: nil, error: "Could not parse data")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                completionHandlerForBookInfo(result: nil, error: "Could not parse data")
            }

            let items = parsedResult["items"] as! [AnyObject]
            
            let book = items[0]
            
            let volumeInfo = book["volumeInfo"] as! [String: AnyObject]

            let bookTitle = volumeInfo["title"] as! String
            
            let authors = volumeInfo["authors"] as! NSArray
            
            var authorString = ""
            for author in authors {
                authorString += (author as! String) + "\n"
            }
            
            print(authorString)
            
            let imageLinks = volumeInfo["imageLinks"] as! [String: AnyObject]
            
            let oldString = imageLinks["thumbnail"] as! String
            let thumbnail = oldString.stringByReplacingOccurrencesOfString("http", withString: "https")
            
            let result = [bookTitle, authorString, thumbnail]

            completionHandlerForBookInfo(result: result, error: "Could not parse data")
        }
        
        task.resume()
    }
    
    class func sharedInstance() -> GoogleClient {
        struct Singleton {
            static var sharedInstance = GoogleClient()
        }
        return Singleton.sharedInstance
    }
}