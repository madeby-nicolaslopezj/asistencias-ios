//
//  Session.swift
//  
//
//  Created by Nicolás López on 11-06-15.
//
//

import Foundation
import CoreData

class Session: NSManagedObject {

    @NSManaged var date: String
    @NSManaged var module: NSNumber
    @NSManaged var course: String
    @NSManaged var students: NSData

}
