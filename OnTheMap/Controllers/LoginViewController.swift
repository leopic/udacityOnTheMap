//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/13/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var textEmail:UITextField!
    @IBOutlet var textPassword:UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        if let student = Student.fetch() {
            completeLogin()
        }
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func showErrorMessage(errorMessage:String) {
        dispatch_async(dispatch_get_main_queue(), {
            var controller = UIAlertController(title: "Error logging in",
                message: errorMessage,
                preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            controller.addAction(action)
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    @IBAction func btnLogin() {
        let username = textEmail.text
        let password = textPassword.text
        
        if username.isEmpty || password.isEmpty {
            showErrorMessage("Make sure you provide both a username and password")
        } else {
            let hud = JGProgressHUD(style: .Light)
            hud.textLabel.text = "Checking your credentials"
            hud.animation = JGProgressHUDFadeZoomAnimation()
            hud.showInView(self.view)
            
            let udacityClient = UdacityClient.sharedInstance()
            udacityClient.logInWithUsername(username, andPassword: password) {
                (success, errorMessage) in
                
                if success {
                    udacityClient.getStudentPublicData({ (userInfo, errorMessage) -> Void in
                        if errorMessage == nil {
                            self.completeLogin()
                        } else {
                            self.showErrorMessage("Unable to retrieve the student's public data")
                        }
                    })
                } else {
                    hud.dismissAfterDelay(0.1)
                    self.showErrorMessage(errorMessage!)
                }
            }
        }
    }
    
    @IBAction func btnSignUp() {
        let signUpURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(signUpURL!)
    }
    
}
