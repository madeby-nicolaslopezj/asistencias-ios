//
//  StudentExtension.swift
//  Asistencias
//
//  Created by Nicolás López on 18-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import CoreData

extension Student {
    
    class func getStudentWithRut(rut: String, managedObjectContext: NSManagedObjectContext) -> Student? {
        
        let fetchRequest = NSFetchRequest(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "rut == %@", rut)
        fetchRequest.fetchLimit = 1;
        
        var error: NSErrorPointer = nil
        var results: Array = managedObjectContext.executeFetchRequest(fetchRequest, error: error)!
        
        if results.count == 1 {
            var student = results[0] as! Student
            return student
        }
        
        return nil
    }
    
    func isInCourse(course: Course) -> Bool {
        let studentId = Meteor.documentKeyForObjectID(self.objectID).documentID as! String
        return course.students.contains(studentId)
    }
}