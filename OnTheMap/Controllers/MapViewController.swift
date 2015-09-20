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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLocations()
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
    
    func displayLoader(message:String) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = message
        hud.animation = JGProgressHUDFadeZoomAnimation()
        hud.showInView(self.view)
        return hud
    }
    
    func updateLocations() {
        let hud = displayLoader("Updating locations")
        
        let parseClient = ParseClient.sharedInstance()
        parseClient.getStudentLocations { (locations, message) -> Void in
            hud.dismissAfterDelay(0.1)
            
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
    
}

