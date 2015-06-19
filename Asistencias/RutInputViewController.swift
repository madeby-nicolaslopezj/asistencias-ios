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
    
    let duration = 0.6
    
    var currentValue: String {
        get {
            return self.inputLabel!.text!
        }
        set(string) {
            self.inputLabel.text = string
            if let student = Student.getStudentWithRut(string, managedObjectContext: Meteor.mainQueueManagedObjectContext) {
                if student.isInCourse(self.coursesShowViewController!.course!) {
                    if self.coursesShowViewController!.session!.studentDidCheck(student) {
                        self.showErrorWithMessage("\(student.name) ya marcó asistencia")
                    } else {
                        self.coursesShowViewController!.session!.addStudent(student)
                        self.showSuccessWithStudentName(student.name)
                    }
                } else {
                    self.showErrorWithMessage("\(student.name) no está en este curso")
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue = ""
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
    
    func showSuccessWithStudentName(name: String) {
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            self.inputLabel.alpha = 0
        }) { (completed) -> Void in
            self.inputLabel.text = name
            
            UIView.animateWithDuration(self.duration, animations: { () -> Void in
                self.inputLabel.alpha = 1
            }, completion: { (completed) -> Void in
                
                UIView.animateWithDuration(self.duration, delay: self.duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.inputLabel.alpha = 0
                }, completion: { (completed) -> Void in
                    self.currentValue = ""
                    self.inputLabel.alpha = 1
                })
                
            })
            
        }
    }
    
    func showErrorWithMessage(message: String) {
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            self.inputLabel.alpha = 0
            }) { (completed) -> Void in
                self.inputLabel.text = message
                self.inputLabel.textColor = UIColor.redColor()
                
                UIView.animateWithDuration(self.duration, animations: { () -> Void in
                    self.inputLabel.alpha = 1
                    }, completion: { (completed) -> Void in
                        
                        UIView.animateWithDuration(self.duration, delay: self.duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.inputLabel.alpha = 0
                            }, completion: { (completed) -> Void in
                                self.currentValue = ""
                                self.inputLabel.alpha = 1
                                self.inputLabel.textColor = UIColor.blackColor()
                        })
                        
                })
                
        }
    }

}
