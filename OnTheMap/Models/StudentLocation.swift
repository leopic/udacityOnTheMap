//
//  StudentLocation
//  On The Map
//
//  A location where a student, well, studies.
//

import Foundation
import MapKit

struct StudentLocation {
    private let MinLatitude:Float = -91.0
    private let MaxLatitude:Float = 91.0
    private let MinLongitude:Float = -181.0
    private let MaxLongitude:Float = 181.0
    
    var objectId:String?
    var uniqueKey:String!
    var firstName:String!
    var lastName:String!
    var mapString:String!
    var mediaURL:String!
    var latitude:Float = 0.0 {
        didSet {
            if latitude < MinLatitude || latitude > MaxLatitude {
                latitude = 0.0
            }
        }
    }
    var longitude:Float = 0.0 {
        didSet {
            if longitude < MinLongitude || latitude > MaxLongitude {
                longitude = 0.0
            }
        }
    }
    var createdAt:NSDate?
    var updatedAt:NSDate?
    
    func asDictionary() -> [String:AnyObject] {
        return [
            PropertyKeys.UniqueKey: self.uniqueKey!,
            PropertyKeys.FirstName: self.firstName!,
            PropertyKeys.LastName: self.lastName!,
            PropertyKeys.MapString: self.mapString!,
            PropertyKeys.MediaURL: self.mediaURL!,
            PropertyKeys.Latitude: self.latitude,
            PropertyKeys.Longitude: self.longitude
        ]
    }
        
    init(fromStudent student:Student) {
        uniqueKey = student.key
        firstName = student.firstName
        lastName = student.lastName
    }
    
    init(fromStudent student:Student, andMapString:String, mediaURL:String, latitude:Float, longitude:Float) {
        uniqueKey = student.key
        firstName = student.firstName
        lastName = student.lastName
        self.mapString = andMapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(fromParseResponse data:[String:AnyObject]) {
        objectId  = data[PropertyKeys.ObjectId] as? String
        uniqueKey = data[PropertyKeys.UniqueKey] as! String
        firstName = data[PropertyKeys.FirstName] as! String
        lastName  = data[PropertyKeys.LastName] as! String
        mapString = data[PropertyKeys.MapString] as! String
        mediaURL  = data[PropertyKeys.MediaURL] as! String
        latitude  = data[PropertyKeys.Latitude] as! Float
        longitude = data[PropertyKeys.Longitude] as! Float
    }
    
    static func createFromResponse(data: [[String:AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for location in data {
            locations.append(StudentLocation(fromParseResponse: location))
        }
        
        return locations
    }
    
    static func createAnnotation(location:StudentLocation) -> MKPointAnnotation {
        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = location.firstName
        let last = location.lastName
        let mediaURL = location.mediaURL
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
    }

    struct PropertyKeys {
        static let FirstName = "firstName"
        static let LastName  = "lastName"
        static let MapString = "mapString"
        static let MediaURL  = "mediaURL"
        static let ObjectId  = "objectId"
        static let UniqueKey = "uniqueKey"
        static let Latitude  = "latitude"
        static let Longitude = "longitude"
    }
    
}
