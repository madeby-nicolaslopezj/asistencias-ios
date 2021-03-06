//
//  RutInputButton.swift
//  Asistencias
//
//  Created by Nicolás López on 16-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit

class RutInputButton: UIButton {
    
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.5
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
    }

}
