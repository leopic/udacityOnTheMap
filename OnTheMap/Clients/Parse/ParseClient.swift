//
//  ParseClient.swift
//  On The Map
//
//  Created by Leo Picado on 9/5/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

class ParseClient:Client {
    
    let baseURL = "https://api.parse.com/"
    
    // should return an array of locations
    func getStudentLocations(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = getBaseNSURLRequest(Methods.StudentLocation)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error...
                println("something totally failed loading student locations...")
                return
            }
            
            Client.parseJSONWithCompletionHandler(data, completionHandler: { (parsedResponse, parsingError) -> Void in
                if parsingError == nil {
                    if let objectId = parsedResponse.valueForKeyPath(JSONResponseKeys.ObjectId) as? String,
                        createdAt = parsedResponse.valueForKeyPath(JSONResponseKeys.CreatedAt) as? String {
                            println("object was created succesfully")
                    } else {
                        println("error creating object")
                    }
                } else {
                    println("object might have been created, but there was an error parsing the response")
                }
            })
            
        }
        task.resume()
        return task
    }
    
    // should return a boolean and a message
    func addStudentLocation(location: StudentLocation, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = getBaseNSURLRequest(Methods.StudentLocation, httpMethod: HTTPMethods.POST)
        var jsonifyError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(location.asDictionary(), options: nil, error: &jsonifyError)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                println("something totally failed adding a student location...")
                return
            }
            
            Client.parseJSONWithCompletionHandler(data, completionHandler: { (parsedResponse, parsingError) -> Void in
                if parsingError == nil {
                    if let objectId = parsedResponse.valueForKeyPath(JSONResponseKeys.ObjectId) as? String,
                        createdAt = parsedResponse.valueForKeyPath(JSONResponseKeys.CreatedAt) as? String {
                            println("object was created succesfully")
                    } else {
                        println("error creating object")
                    }
                } else {
                    println("object might have been created, but there was an error parsing the response")
                }
            })
        }
        
        task.resume()
        return task
    }
    
    private func getBaseNSURLRequest(method:String, httpMethod:String = HTTPMethods.GET) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(baseURL)\(method)")!)
        request.addValue(Credentials.ApplicationId, forHTTPHeaderField: Headers.AplicationId)
        request.addValue(Credentials.APIKey, forHTTPHeaderField: Headers.RestAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = httpMethod
        return request
    }
    
    // MARK: - Constants
    struct Headers {
        static let AplicationId = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct Credentials {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct Methods {
        static let StudentLocation = "1/classes/StudentLocation"
    }
    
    struct JSONBodyKeys {
        
    }
    
    struct JSONResponseKeys {
        static let CreatedAt = "createdAt"
        static let ObjectId = "objectId"
    }
    
    // Singleton
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
