//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/12/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func showLoader(message:String, view:UIView) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = message
        hud.animation = JGProgressHUDFadeZoomAnimation()
        hud.showInView(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return hud
    }
    
    func hideLoader(hud:JGProgressHUD) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        hud.dismissAfterDelay(0.1)
    }
    
    func showErrorMessage(errorMessage:String, context:UIViewController) {
        dispatch_async(dispatch_get_main_queue(), {
            var controller = UIAlertController(title: "Oops!",
                message: errorMessage,
                preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            controller.addAction(action)
            context.presentViewController(controller, animated: true, completion: nil)
        })
    }

}

