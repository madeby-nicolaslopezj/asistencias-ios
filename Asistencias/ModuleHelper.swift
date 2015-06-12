//
//  ModuleHelper.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation
import Timepiece

class ModuleHelper {
    
    class var date: String {
        let now = NSDate()
        return now.stringFromFormat("dd-MM-yyyy")
    }
    
    class var module: Int {
        let now = NSDate()
        
        let module1 = now.change(hour: 9, minute: 50)
        
        if now < module1 {
            return 1
        }
        
        let module2 = now.change(hour: 11, minute: 20)
        
        if now < module2 {
            return 2
        }
        
        let module3 = now.change(hour: 12, minute: 50)
        
        if now < module3 {
            return 3
        }
        
        let module4 = now.change(hour: 14, minute: 50)
        
        if now < module4 {
            return 4
        }
        
        let module5 = now.change(hour: 16, minute: 20)
        
        if now < module5 {
            return 5
        }
        
        let module6 = now.change(hour: 17, minute: 50)
        
        if now < module6 {
            return 6
        }
        
        let module7 = now.change(hour: 19, minute: 20)
        
        if now < module7 {
            return 7
        }

        return 8
    }
    
}