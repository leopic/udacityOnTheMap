//
//  Student.swift
//  On The Map
//
//  Created by Leo Picado on 9/5/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

class Student:NSObject, NSCoding {
    var firstName:String!
    var lastName:String!
    var email:String!
    var key:String!
    var imageURL:NSURL?
    
    // So we can store the object in NSUserDefaults
    required init(coder aDecoder: NSCoder) {
        if let firstName = aDecoder.decodeObjectForKey("firstName") as? String,
            lastName = aDecoder.decodeObjectForKey("lastName") as? String,
            email = aDecoder.decodeObjectForKey("email") as? String,
            key = aDecoder.decodeObjectForKey("key") as? String {
                self.firstName = firstName
                self.lastName = lastName
                self.email = email
                self.key = key
        }
    }
    
    // So we can get it back from NSUserDefaults
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.key, forKey: "key")
    }
    
    /**
    Create a student from the result of UdacityClient->getPublicData
    
    :param: dictionary Parsed JSON with a "user" object wrapping all the contents
    
    :returns: Student or nil
    */
    init(dictionary: [String:AnyObject]) {
        if let user = dictionary[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
            firstName = user[UdacityClient.JSONResponseKeys.FirstName] as! String
            lastName = user[UdacityClient.JSONResponseKeys.LastName] as! String
            if let emailObj = user[UdacityClient.JSONResponseKeys.EmailObj] as? [String:AnyObject] {
                email = emailObj[UdacityClient.JSONResponseKeys.EmailAddress] as! String
            }
            key = user[UdacityClient.JSONResponseKeys.Key] as! String
            if let imageURLString = user[UdacityClient.JSONResponseKeys.ImageURL] as? String {
                imageURL = NSURL(string: imageURLString)
            }
        }
    }
    
}
