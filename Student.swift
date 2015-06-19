//
//  Student.swift
//  Asistencias
//
//  Created by Nicolás López on 18-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import CoreData

class Student: NSManagedObject {

    @NSManaged var digit: String
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var omegaId: String
    @NSManaged var rut: String
    @NSManaged var course: NSSet

}
