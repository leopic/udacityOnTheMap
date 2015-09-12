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

    func getStudentLocations(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = getBaseNSURLRequest(Methods.StudentLocation)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        return task
    }

    func addStudentLocation(jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = getBaseNSURLRequest(Methods.StudentLocation, httpMethod: HTTPMethods.POST)
        var jsonifyError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
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
    
    }
    
    // Singleton
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
