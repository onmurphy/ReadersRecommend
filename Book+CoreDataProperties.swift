//
//  Book+CoreDataProperties.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/18/16.
//  Copyright © 2016 Murphy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var title: String?
    @NSManaged var isbn: String?
    @NSManaged var authors: String?
    @NSManaged var image: NSData?

}
