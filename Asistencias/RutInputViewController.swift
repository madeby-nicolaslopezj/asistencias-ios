//
//  RutInputViewController.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit

class RutInputViewController: UIViewController {
    
    var coursesShowViewController: CoursesShowViewController?
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var ceroButton: UIButton!
    @IBOutlet weak var earseButton: UIButton!
    
    var currentValue: String {
        get {
            return self.inputLabel!.text!
        }
        set(string) {
            self.inputLabel.text = string
            if let studentName = coursesShowViewController?.getStudentNameWithRut(string) {
                self.inputLabel.text = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentValue = "1839724"
    }

    
    @IBAction func buttonClicked(sender: UIButton) {
        var tag = sender.tag
        
        if tag == 11 {
            if currentValue != "" {
                currentValue = dropLast(currentValue)
            }
            
            return
        }
        
        self.buttonClickedWithNumber("\(tag)")
    }

    func buttonClickedWithNumber(number: String) {
        
        currentValue = currentValue + number
        
    }

}
