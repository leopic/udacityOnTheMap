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
    var appDelegate:AppDelegate!
    
    // - MARK: UIView Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        student = Student.fetch()!
        locationTextField.delegate = self
        urlTextField.delegate = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        step1.hidden = false
        step2.hidden = false
        step1.alpha = 0.0
        step2.alpha = 0.0
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.step1.alpha = 1.0
        })
    }
    
    // - MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.locationTextField.isFirstResponder() {
            if self.locationTextField.text.isEmpty {
                return false
            } else {
                textField.resignFirstResponder()
                tapOnFindButton()
                return true
            }
        }
        
        if self.urlTextField.isFirstResponder() {
            if self.urlTextField.text.isEmpty {
                return false
            } else {
                textField.resignFirstResponder()
                tapOnSubmitButton()
                return true
            }
        }
        
        return true
    }
    
    // - MARK: Interactions
    @IBAction func tapOnFindButton() {
        let hud = appDelegate.showLoader("Searching location", view: self.view)
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = self.locationTextField.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (response, error) -> Void in
            self.appDelegate.hideLoader(hud)
            
            if error == nil {
                var pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = self.locationTextField.text
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
                var pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                self.map.centerCoordinate = pointAnnotation.coordinate
                self.map.addAnnotation(pointAnnotation)
                UIView.animateWithDuration(0.6, animations: { () -> Void in
                    self.step2.alpha = 1.0
                    self.step1.alpha = 0.0
                })
            } else {
                self.appDelegate.showErrorMessage("Unable to find such location, please try again",
                    context: self)
            }
        }
        
    }
    
    @IBAction func tapOnSubmitButton() {
        let hud = appDelegate.showLoader("Adding location", view: self.view)
        let studentLocation = StudentLocation()
        studentLocation.uniqueKey = student.key
        studentLocation.firstName = student.firstName
        studentLocation.lastName = student.lastName
        studentLocation.mapString = locationTextField.text
        studentLocation.mediaURL = urlTextField.text
        studentLocation.latitude = Float(self.map.centerCoordinate.latitude)
        studentLocation.longitude = Float(self.map.centerCoordinate.longitude)
        
        ParseClient.sharedInstance().addStudentLocation(studentLocation, completionHandler: {
            (success, error) -> Void in
            self.appDelegate.hideLoader(hud)
            
            if success {
                self.goBackToTabBar()
            } else {
                self.appDelegate.showErrorMessage(error, context: self)
            }
        })
    }
    
    @IBAction func tapOnCancelButton() {
        goBackToTabBar()
    }
    
    // - MARK: Utils
    
    /**
    View controller dismissal.
    */
    func goBackToTabBar() {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}
