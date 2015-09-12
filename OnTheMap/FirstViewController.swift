//
//  FirstViewController.swift
//  On The Map
//
//  Created by Leo Picado on 9/1/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    let username = "udacity@leonardopicado.com"
    let password = "123queso"
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        udacityTests()
        parseTests()
    }
    
    private func parseTests() {
        let parseClient = ParseClient.sharedInstance()
        parseClient.getStudentLocations { (result, error) -> Void in
            println(result)
            println(error)
        }
        
        parseClient.addStudentLocation([
            "uniqueKey": "32343534543543",
            "firstName": "la musica",
            "lastName": "los musicos",
            "mapString": "Mountain View, CA",
            "mediaURL": "https://udacity.com",
            "latitude": 37.386052,
            "longitude": -122.083851
            ], completionHandler: { (result, error) -> Void in
                println(result)
                println(error)
        })
        
    }
    
    private func udacityTests() {
        var udacityClient = UdacityClient.sharedInstance()
        
        // login
        udacityClient.logInWithUsername(username, andPassword: password) {
            (success, errorMessage) in
            
            if success {
                
                // get public data
                udacityClient.getStudentPublicData({ (userInfo, errorMessage) -> Void in
                    if errorMessage == nil {
                        var student = Student(dictionary: userInfo! as! [String:AnyObject])
                        println("Student key: \(student.key)")
                        
                        // log out
                        udacityClient.logOut({ (success, errorMessage) -> Void in
                            if success {
                                println("logged out succesfully :)")
                            } else {
                                println("error loggin out :(")
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

