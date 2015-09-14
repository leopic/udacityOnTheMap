//
//  FirstViewController.swift
//  On The Map
//
//  Created by Leo Picado on 9/1/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var student:Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        student = Student.fetch()!
        
        let parseClient = ParseClient.sharedInstance()
        parseClient.getStudentLocations { (locations, message) -> Void in
            if locations == nil {
                println(message)
            } else {
                var annotations = [MKPointAnnotation]()

                for location in locations! {
                    annotations.append(StudentLocation.createAnnotation(location))
                }
                
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    
    // MARK: - Clients Test
    
    private func parseTests() {
        let parseClient = ParseClient.sharedInstance()
        parseClient.getStudentLocations { (locations, message) -> Void in
            println(locations)
            println(message)
        }
        
        let studentLocation = StudentLocation()
        studentLocation.uniqueKey = "32343534543543"
        studentLocation.firstName = "Leo"
        studentLocation.lastName = "Picado"
        studentLocation.mapString = "Mountain View, CA"
        studentLocation.mediaURL = "http://leonardopicado.com"
        studentLocation.latitude = 37.386052
        studentLocation.longitude = -122.083851
        
        parseClient.addStudentLocation(studentLocation, completionHandler: { (result, error) -> Void in
            println(result)
            println(error)
        })
        
    }
    
    private func udacityTests() {
        var udacityClient = UdacityClient.sharedInstance()
        
        udacityClient.logInWithUsername("user", andPassword: "pass") {
            (success, errorMessage) in
            
            if success {
                println("udacityClient.logInWithUsername")
                
                udacityClient.getStudentPublicData({ (userInfo, errorMessage) -> Void in
                    if errorMessage == nil {
                        var student = Student(dictionary: userInfo! as! [String:AnyObject])
                        println("udacityClient.getStudentPublicData")
                        
                        let parseClient = ParseClient.sharedInstance()
                        let location = StudentLocation(fromStudent: student)
                        location.mapString = "Mountain View, CA"
                        location.mediaURL = "http://leonardopicado.com"
                        location.latitude = 37.386052
                        location.longitude = -122.083851
                        
                        parseClient.addStudentLocation(location, completionHandler: { (success, message) -> Void in
                            if success {
                                println("parseClient.addStudentLocation")
                                
                                udacityClient.logOut({ (success, errorMessage) -> Void in
                                    if success {
                                        println("udacityClient.logOut")
                                    }
                                })
                            }
                        })
                        
                    } else {
                        if let error = errorMessage {
                            println(error)
                        }
                    }
                })
                
            } else {
                if let error = errorMessage {
                    println(error)
                }
            }
        }
    }
    
}

