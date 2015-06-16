//
//  Check.swift
//  Asistencias
//
//  Created by Nicolás López on 16-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import CoreData

class Check: NSManagedObject {

    @NSManaged var session: String
    @NSManaged var student: String

}
