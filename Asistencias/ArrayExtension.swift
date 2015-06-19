//
//  ArrayExtension.swift
//  Asistencias
//
//  Created by Nicolás López on 18-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import Foundation

extension Array {
    
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
}