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
    
    @IBOutlet weak var connectingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionDidChange", name: METDDPClientDidChangeConnectionStatusNotification, object: nil)
        connectionDidChange()
        
        //self.view.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let email = userDefaults.stringForKey("UserEmail") {
            if let password = userDefaults.stringForKey("UserPassword") {
                login(email, password: password)
            } else {
               self.showAlertWithError("Debes especificar la contraseña en los ajustes")
            }
        } else {
            self.showAlertWithError("Debes especificar el email en los ajustes")
        }
    }
    
    
    func showAlertWithError(error: String) {
        var alertController = UIAlertController(title: "Error",
            message: error,
            preferredStyle: UIAlertControllerStyle.Alert)
        

        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (_) in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(settingsUrl!)
        }
        
        alertController.addAction(cancelAction)
        
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
                self.showAlertWithError("Ocurrió un error al autenticarse con el servidor, revisa las credenciales en los ajustes")
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
        if segue.identifier == "showSettings" {
            
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
    
    // MARK: Meteor Delegate
    
    func connectionDidChange() {
        println("Connection Status: \(Meteor.connectionStatus)")
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            if Meteor.connectionStatus == METDDPConnectionStatus.Waiting {
                self.connectingLabel.text = "Esperando para conectar..."
                self.connectingLabel.alpha = 1
            } else if Meteor.connectionStatus == METDDPConnectionStatus.Connecting {
                self.connectingLabel.text = "Conectando..."
                self.connectingLabel.alpha = 1
            } else if Meteor.connectionStatus == METDDPConnectionStatus.Failed {
                self.connectingLabel.text = "Error de conexión"
                self.connectingLabel.alpha = 1
            } else if Meteor.connectionStatus == METDDPConnectionStatus.Offline {
                self.connectingLabel.text = "Desconectado"
                self.connectingLabel.alpha = 1
            } else {
                self.connectingLabel.alpha = 0
            }
            
        }) { (finished) -> Void in
        }
        
    }
    

}
