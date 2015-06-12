//
//  Student.swift
//  
//
//  Created by Nicolás López on 11-06-15.
//
//

import Foundation
import CoreData

class Student: NSManagedObject {

    @NSManaged var digit: String
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var omegaId: String
    @NSManaged var rut: String

}
