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
        urlTextField.delegate = self
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
    
    // TODO: display location in map
    @IBAction func tapOnFindButton() {        
        let hud = displayLoader("Searching for location")
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = self.locationTextField.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (response, error) -> Void in
            hud.dismissAfterDelay(0.1)

            if error == nil {
                var pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = self.locationTextField.text
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
                var pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                self.step1.hidden = true
                self.step2.hidden = false
                self.map.centerCoordinate = pointAnnotation.coordinate
                self.map.addAnnotation(pointAnnotation)
            } else {
                println(error.localizedDescription)
            }
        }
        
    }
    
    // TODO: fetch lat and long from map
    @IBAction func tapOnSubmitButton() {
        let hud = displayLoader("Adding location")
        let parseClient = ParseClient.sharedInstance()
        let studentLocation = StudentLocation()
        studentLocation.uniqueKey = student.key
        studentLocation.firstName = student.firstName
        studentLocation.lastName = student.lastName
        studentLocation.mapString = locationTextField.text
        studentLocation.mediaURL = urlTextField.text
        studentLocation.latitude = Float(self.map.centerCoordinate.latitude)
        studentLocation.longitude = Float(self.map.centerCoordinate.longitude)
        
        parseClient.addStudentLocation(studentLocation, completionHandler: { (success, error) -> Void in
            hud.dismissAfterDelay(0.1)
            
            if success {
                self.goBackToTabBar()
            } else {
                println(error)
            }
        })
    }
    
    @IBAction func tapOnCancelButton() {
        goBackToTabBar()
    }
    
    func goBackToTabBar() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayLoader(message:String) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = message
        hud.animation = JGProgressHUDFadeZoomAnimation()
        hud.showInView(self.view)
        return hud
    }
    
}
