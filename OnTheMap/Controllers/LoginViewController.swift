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
    
    @IBAction func btnLogin() {
        
    }
    
    @IBAction func btnSignUp() {
        let signUpURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(signUpURL!)
    }

}
