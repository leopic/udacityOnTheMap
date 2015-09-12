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
    var objectId:String?
    var uniqueKey:String!
    var firstName:String!
    var lastName:String!
    var mapString:String!
    var mediaURL:String!
    var latitude:Float!
    var longitude:Float!
    var createdAt:NSDate?
    var updatedAt:NSDate?
    
    func asDictionary() -> [String:AnyObject] {
        return [
            "uniqueKey": self.uniqueKey!,
            "firstName": self.firstName!,
            "lastName": self.lastName!,
            "mapString": self.mapString!,
            "latitude": self.latitude!,
            "longitude": self.longitude!,
            "mediaURL": self.mediaURL!
        ]
    }
}
