//
//  StudentMethods.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/13/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

extension Student {
    /**
    Stores the current student in the NSUserDefaults.
    
    :returns: true upon a succesfull write/read.
    */
    class func save(student:Student) -> Bool {
        let ObjectKey = "student"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(student), forKey: ObjectKey)
        
        if let storedStudent = Student.fetch() {
            return student.firstName == storedStudent.firstName
        }
        
        return false
    }
    
    /**
    Retrieves the previously stored student from NSUserDefaults.
    
    :returns: Student|nil
    */
    class func fetch() -> Student? {
        let ObjectKey = "student"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let studentData = userDefaults.objectForKey(ObjectKey) as? NSData {
            if let student = NSKeyedUnarchiver.unarchiveObjectWithData(studentData) as? Student {
                return student
            }
        }
        
        return nil
    }
    
    /**
    Removes the stored student from NSUserDefaults.
    */
    class func remove() {
        let ObjectKey = "student"
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(ObjectKey)
    }
    
}