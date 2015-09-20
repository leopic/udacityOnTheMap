//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/19/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var urlTextField:UITextField!
    @IBOutlet var findButton:UIButton!
    @IBOutlet var submitButton:UIButton!
    @IBOutlet var step1:UIView!
    @IBOutlet var step2:UIView!
    @IBOutlet var map:MKMapView!
    
    var student:Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        student = Student.fetch()!
        locationTextField.delegate = self
        println(student.firstName)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        step1.hidden = false
        step2.hidden = true
    }
    
    // TODO: consider both textfields
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.locationTextField.text.isEmpty {
            return false
        } else {
            textField.resignFirstResponder()
            tapOnFindButton()
            return true
        }
    }
    
    // TODO: hide step two, display step one
    @IBAction func tapOnFindButton() {
        println("Find \(self.locationTextField.text)")
        step1.hidden = true
        step2.hidden = false
    }
    
    // TODO: actually submit this
    @IBAction func tapOnSubmitButton() {
        println("Submit \(self.urlTextField.text)!")
        goBackToTabBar()
    }
    
    @IBAction func tapOnCancelButton() {
        goBackToTabBar()
    }
    
    func goBackToTabBar() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
}
