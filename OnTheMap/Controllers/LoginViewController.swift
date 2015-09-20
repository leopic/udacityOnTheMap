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
    
    var appDelegate:AppDelegate!
    
    // - MARK: - UIView Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        if let student = Student.fetch() {
            completeLogin()
        }
    }
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    // - MARK: - Interactions
    @IBAction func btnLogin() {
        let username = textEmail.text
        let password = textPassword.text
        
        if username.isEmpty || password.isEmpty {
            self.appDelegate.showErrorMessage("Make sure you provide both a username and password", context: self)
        } else {
            let hud = appDelegate.showLoader("Checking your credentials", view: self.view)
            let udacityClient = UdacityClient.sharedInstance()
            udacityClient.logInWithUsername(username, andPassword: password) {
                (success, errorMessage) in
                
                if success {
                    udacityClient.getStudentPublicData({ (userInfo, errorMessage) -> Void in
                        if errorMessage == nil {
                            self.completeLogin()
                        } else {
                            self.appDelegate.showErrorMessage("Unable to retrieve the student's public data", context: self)
                        }
                    })
                } else {
                    self.appDelegate.hideLoader(hud)
                    self.appDelegate.showErrorMessage(errorMessage!, context: self)
                }
            }
        }
    }
    
    @IBAction func btnSignUp() {
        let signUpURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(signUpURL!)
    }
    
    // - MARK: - Utils
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
}
