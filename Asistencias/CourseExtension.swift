//
//  CourseExtension.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import CoreData

extension Course {
    
    var currentSession: Session? {
        let courseId: String = Meteor.documentKeyForObjectID(self.objectID).documentID as! String
        let module: Int = ModuleHelper.module
        let currentDate: String = ModuleHelper.date
        
        let fetchRequest = NSFetchRequest(entityName: "Session")
        fetchRequest.predicate = NSPredicate(format: "course == %@ AND module == %i AND date == %@", courseId, module, currentDate)
        fetchRequest.fetchLimit = 1;
        
        var error: NSErrorPointer = nil
        
        var results: Array = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: error)!
        
        if results.count == 1 {
            return results[0] as? Session
        }
        
        return nil
    }
    
}