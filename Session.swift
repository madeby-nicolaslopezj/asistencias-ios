//
//  Session.swift
//  Asistencias
//
//  Created by Nicolás López on 10-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import CoreData

class Session: NSManagedObject {

    @NSManaged var module: NSNumber
    @NSManaged var date: String
    @NSManaged var students: Student

}
