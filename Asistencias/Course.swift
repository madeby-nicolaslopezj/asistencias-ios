//
//  Course.swift
//  
//
//  Created by Nicolás López on 11-06-15.
//
//

import Foundation
import CoreData

class Course: NSManagedObject {

    @NSManaged var abbreviation: String
    @NSManaged var hidden: NSNumber
    @NSManaged var name: String
    @NSManaged var numberOfStudents: String
    @NSManaged var omegaCode: String
    @NSManaged var periodId: String
    @NSManaged var periodName: String
    @NSManaged var section: String
    @NSManaged var teacher: String
    @NSManaged var students: NSData

}
