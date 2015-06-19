//
//  SessionExtension.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import Meteor

extension Session {
    
    func addStudent(student: Student) {
        println("Adding student to session")
        let studentId: String = Meteor.documentKeyForObjectID(student.objectID).documentID as! String
        let sessionId: String = Meteor.documentKeyForObjectID(self.objectID).documentID as! String
   
        let check = NSEntityDescription.insertNewObjectForEntityForName("Check", inManagedObjectContext:self.managedObjectContext!) as! Check
        
        check.session = sessionId
        check.student = studentId
        
        var error = NSErrorPointer()
        if !self.managedObjectContext!.save(error) {
            println("Encountered error saving objects: \(error)")
        } else {
            println("Check created")
        }
    }
    
    func studentDidCheck(student: Student) -> Bool {
        let studentId: String = Meteor.documentKeyForObjectID(student.objectID).documentID as! String
        let sessionId: String = Meteor.documentKeyForObjectID(self.objectID).documentID as! String
        
        let fetchRequest = NSFetchRequest(entityName: "Check")
        fetchRequest.predicate = NSPredicate(format: "session == %@ && student == %@", sessionId, studentId)
        fetchRequest.fetchLimit = 1;
        
        var error: NSErrorPointer = nil
        var results: Array = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: error)!
        
        return results.count != 0
    }
    
}