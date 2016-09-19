//
//  Book.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/18/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import CoreData


class Book: NSManagedObject {

    convenience init(title: String, isbn: String, authors: String, image: NSData, context : NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entityForName("Book",
                                                       inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.title = title
            self.isbn = isbn
            self.authors = authors
            self.image =  image
        }else{
            fatalError("Unable to find Entity name!")
        }
        
    }

}
