//
//  TableViewController
//  OnTheMap
//
//  Created by Leo Picado on 9/12/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    
    var locations = [StudentLocation]()
    var appDelegate:AppDelegate!
    
    // - MARK: UIView Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
    
    // - MARK: Interactions
    @IBAction func tapOnRefreshButton() {
        updateLocations()
    }
    
    @IBAction func tapOnLogOutButton(sender: AnyObject) {
        let hud = appDelegate.showLoader("Logging out", view: self.view)
        UdacityClient.sharedInstance().logOut { (success, errorMessage) -> Void in
            self.appDelegate.hideLoader(hud)
            
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                self.appDelegate.showErrorMessage(errorMessage!, context: self)
            }
        }
    }
    
    // - MARK: Utils
    
    /**
    Update student locations, reload table data when done.
    */
    func updateLocations() {
        let hud = appDelegate.showLoader("Updating locations", view: self.view)
        ParseClient.sharedInstance().getStudentLocations { (locations, message) -> Void in
            self.appDelegate.hideLoader(hud)
            
            if locations == nil {
                self.appDelegate.showErrorMessage(message, context: self)
            } else {
                self.locations = locations!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }

}

