//
//  Course.swift
//  Asistencias
//
//  Created by Nicolás López on 18-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import CoreData

class Course: NSManagedObject {

    @NSManaged var abbreviation: String
    @NSManaged var currentSessionId: String
    @NSManaged var hidden: NSNumber
    @NSManaged var name: String
    @NSManaged var numberOfStudents: String
    @NSManaged var omegaCode: String
    @NSManaged var periodId: String
    @NSManaged var periodName: String
    @NSManaged var section: String
    @NSManaged var teacher: String
    @NSManaged var students: NSSet

}
