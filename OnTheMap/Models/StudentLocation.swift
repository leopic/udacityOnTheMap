//
//  StudentLocation.swift
//  On The Map
//
//  Created by Leo Picado on 9/5/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

//import Parse
//class StudentLocation:PFObject {

class StudentLocation {
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
            "uniqueKey": self.uniqueKey!,
            "firstName": self.firstName!,
            "lastName": self.lastName!,
            "mapString": self.mapString!,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "mediaURL": self.mediaURL!
        ]
    }
    
    init() {}
    
    convenience init(fromStudent student:Student) {
        self.init()
        uniqueKey = student.key
        firstName = student.firstName
        lastName = student.lastName
    }
}
