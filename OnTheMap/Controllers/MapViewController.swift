//
//  MapViewController
//  On The Map
//
//  Displays last 100 entries as pins on the map.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var appDelegate:AppDelegate!
    
    // - MARK: - UIView Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLocations()
    }
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.mapView.delegate = self
    }
    
    // - MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    // MARK: - Interactions
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
    
    // MARK: - Utils
    
    /**
    Update locations from parse, add pins to the map.
    */
    func updateLocations() {
        let hud = appDelegate.showLoader("Updating locations", view: self.view)
        ParseClient.sharedInstance().getStudentLocations { (locations, message) -> Void in
            self.appDelegate.hideLoader(hud)
            
            if locations == nil {
                self.appDelegate.showErrorMessage(message, context: self)
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

