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
        let hud = JGProgressHUD(style: .Light)
        hud.textLabel.text = "logging in..."
        hud.animation = JGProgressHUDFadeZoomAnimation()
        hud.showInView(self.view)
        hud.dismissAfterDelay(0.8)
    }
    
    @IBAction func btnSignUp() {
        let signUpURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(signUpURL!)
    }

}
