//
//  GoogleConstants.swift
//  a
//
//  Created by Olivia Murphy on 10/12/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

extension GoogleClient {
    struct Constants {
        static let partialUrl = "https://www.googleapis.com/books/v1/volumes?q=ISBN:"
        static let parseError = "Could not parse data"
        static let errorMessage = "There was an error in the request"
        static let dataError = "No data was returned"
    }
    
    struct JSONResponseKeys {
        static let items = "items"
        static let volumeInfo = "volumeInfo"
        static let title = "title"
        static let authors = "authors"
        static let imageLinks = "imageLinks"
        static let thumbnail = "thumbnail"
    }
}
