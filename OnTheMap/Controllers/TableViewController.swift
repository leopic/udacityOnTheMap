//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/12/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    var locations = [StudentLocation]()
    
    // - MARK: UIViewController Delegate
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLocations()
    }
    
    // - MARK: UITableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let studentLocation = locations[indexPath.row]
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = locations[indexPath.row]
        let url = NSURL(string: studentLocation.mediaURL)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func tapOnRefreshButton() {
        updateLocations()
    }
    
    @IBAction func tapOnLogOutButton(sender: AnyObject) {
        let hud = displayLoader("Logging out")
        let udacityClient = UdacityClient.sharedInstance()
        
        udacityClient.logOut { (success, errorMessage) -> Void in
            hud.dismissAfterDelay(0.1)
            
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                println(errorMessage)
            }
        }
    }
    
    func updateLocations() {
        let hud = displayLoader("Updating locations")
        
        let parseClient = ParseClient.sharedInstance()
        parseClient.getStudentLocations { (locations, message) -> Void in
            hud.dismissAfterDelay(0.1)
            
            if locations == nil {
                println(message)
            } else {
                self.locations = locations!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func displayLoader(message:String) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = message
        hud.animation = JGProgressHUDFadeZoomAnimation()
        hud.showInView(self.view)
        return hud
    }

}

