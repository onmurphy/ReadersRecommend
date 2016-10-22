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
        let url = Constants.partialUrl + "ISBN:" + isbn
        let requestURL: NSURL = NSURL(string: url)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(requestURL) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForBookInfo(result: nil, error: Constants.errorMessage)
                return
            }
            
            guard let data = data else {
                completionHandlerForBookInfo(result: nil, error: Constants.dataError)
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                completionHandlerForBookInfo(result: nil, error: Constants.parseError)
            }

            
            if let items = parsedResult[JSONResponseKeys.items] as? [AnyObject] {
                let book = items[0]
                
                let volumeInfo = book[JSONResponseKeys.volumeInfo] as! [String: AnyObject]
                
                let bookTitle = volumeInfo[JSONResponseKeys.title] as! String
                
                let authors = volumeInfo[JSONResponseKeys.authors] as! NSArray
                
                var authorString = "by: "
                for author in authors {
                    authorString += (author as! String) + "\n"
                }
                
                let imageLinks = volumeInfo[JSONResponseKeys.imageLinks] as! [String: AnyObject]
                
                let oldString = imageLinks[JSONResponseKeys.thumbnail] as! String
                let thumbnail = oldString.stringByReplacingOccurrencesOfString("http", withString: "https")
                
                let result = [bookTitle, authorString, thumbnail]
                
                completionHandlerForBookInfo(result: result, error: nil)
            } else {
                completionHandlerForBookInfo(result: nil, error: Constants.parseError)
            }
        }
        
        task.resume()
    }
    
    func searchBook(searchString: String, completionHandlerForBookInfo: (result: [[String]]?, error: String?) -> Void) {
        
        var results : [[String]] = []
        
        var isbn : String = ""
        
        let newString = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        let url = Constants.partialUrl + newString + "&maxResults=20"
        
        let requestURL: NSURL = NSURL(string: url)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(requestURL) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForBookInfo(result: nil, error: Constants.errorMessage)
                return
            }
            
            guard let data = data else {
                completionHandlerForBookInfo(result: nil, error: Constants.dataError)
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                completionHandlerForBookInfo(result: nil, error: Constants.parseError)
            }
            
            if let items = parsedResult[JSONResponseKeys.items] as? [AnyObject] {
                for book in items {
                    let volumeInfo = book[JSONResponseKeys.volumeInfo] as! [String: AnyObject]

                    guard let bookTitle = volumeInfo[JSONResponseKeys.title] as? String else {
                        continue
                    }
                    
                    guard let authors = volumeInfo[JSONResponseKeys.authors] as? NSArray else {
                        continue
                    }
                    
                    guard let industryIdentifiers = volumeInfo["industryIdentifiers"] as? NSArray else {
                        continue
                    }
                    
                    guard let identifiers = industryIdentifiers[0] as? [String: AnyObject] else {
                        continue
                    }
                    
                    let type = identifiers["type"] as! String
                    
                    if type == "ISBN_13" {
                        isbn = identifiers["identifier"] as! String
                    } else {
                        continue
                    }
                    
                    var authorString = "by: "
                    for author in authors {
                        authorString += (author as! String) + "\n"
                    }
                    
                    let imageLinks = volumeInfo[JSONResponseKeys.imageLinks] as? [String: AnyObject]
                    
                    guard let oldString = imageLinks![JSONResponseKeys.thumbnail] as? String else {
                        continue
                    }
                    
                    let thumbnail = oldString.stringByReplacingOccurrencesOfString("http", withString: "https")
                    
                    let result = [bookTitle, authorString, thumbnail, isbn]
                    
                    results.append(result)
                }
                    
                completionHandlerForBookInfo(result: results, error: nil)

            }
                
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
