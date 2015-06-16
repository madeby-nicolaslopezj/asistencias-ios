//
//  LoginViewController.swift
//  Asistencias
//
//  Created by Nicolás López on 10-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit
import Meteor

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        //showLoginAlert()
        self.login("app@uai.cl", password: "12345678")
    }
    
    
    func showLoginAlert() {
        var alertController = UIAlertController(title: "Autenticarse",
            message: "Introduce las credenciales",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as! UITextField
            let passwordTextField = alertController.textFields![1]as! UITextField
            
            self.login(loginTextField.text, password: passwordTextField.text)
        }
        loginAction.enabled = false
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text != ""
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }
        
        alertController.addAction(loginAction)
        //alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func login(email: String, password: String) {
        print("Loggin in... ")
        println(email)
        
        Meteor.loginWithEmail(email, password: password, completionHandler: { (error) in
            if error == nil {
                println("Logged in!")
                self.performSegueWithIdentifier("loginToCoursesIndex", sender: self)
            } else {
                println("Error loggin in")
                println(error)
                self.showLoginAlert()
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginToCoursesIndex" {
            if let controller = segue.destinationViewController as? UIViewController {
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .Custom
            }
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = MainTransition()
        transition.transitionMode = .Present
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = MainTransition()
        transition.transitionMode = .Dismiss
        return transition
    }

}
