//
//  StudentLocationStore
//  OnTheMap
//
//  Centralized store for all student location retrievals.
//

import Foundation

class StudentLocationStore:NSObject, UITableViewDataSource {
    var locations = [StudentLocation]()
    
    // - MARK: UITableViewDataSource Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let studentLocation = itemAtIndexPath(indexPath)
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = "From \(studentLocation.mapString)"
        return cell
    }
    
    func get(completionHandler: (locations: [StudentLocation]?, message:String) -> ()) {
        ParseClient.sharedInstance().getStudentLocations { (fetchedLocations, message) -> Void in
            if let locations = fetchedLocations {
                self.locations = locations
                completionHandler(locations: self.locations, message: message)
            }
        }
    }
    
    func itemAtIndexPath(indexPath:NSIndexPath) -> StudentLocation {
        return locations[indexPath.row]
    }
    
}
