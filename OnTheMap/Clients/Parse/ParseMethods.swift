//
//  ParseMethods.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/12/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler: (locations: [StudentLocation]?, message: String) -> Void) {
        let request = getBaseNSURLRequest(Methods.StudentLocation)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error...
                println("something totally failed loading student locations...")
                return
            }
            
            Client.parseJSONWithCompletionHandler(data, completionHandler: { (parsedResponse, parsingError) -> Void in
                if parsingError == nil {
                    if let results = parsedResponse.valueForKeyPath(JSONResponseKeys.Results) as? [[String:AnyObject]] {
                        let locations = StudentLocation.createFromResponse(results)
                        completionHandler(locations: locations, message: "Success retrieving locations")
                    } else {
                        completionHandler(locations: nil, message: "No results block in locations response")
                    }
                } else {
                    completionHandler(locations: nil, message: "There was an error parsing the response for locations")
                }
            })
        }
        
        task.resume()
    }
    
    func addStudentLocation(location: StudentLocation, completionHandler: (success: Bool, message: String) -> Void) {
        let request = getBaseNSURLRequest(Methods.StudentLocation, httpMethod: HTTPMethods.POST)
        var jsonifyError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(location.asDictionary(), options: nil, error: &jsonifyError)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil {
                Client.parseJSONWithCompletionHandler(data, completionHandler: { (parsedResponse, parsingError) -> Void in
                    if parsingError == nil {
                        if let objectId = parsedResponse.valueForKeyPath(JSONResponseKeys.ObjectId) as? String,
                            createdAt = parsedResponse.valueForKeyPath(JSONResponseKeys.CreatedAt) as? String {
                                completionHandler(success: true, message: "Location created succesfully")
                        } else {
                            completionHandler(success: false, message: "Unable to verify location creation")
                        }
                    } else {
                        completionHandler(success: false, message: "Parsing error while adding location")
                    }
                })
            } else {
                completionHandler(success: false, message: "Error while adding student location")
            }
        }
        
        task.resume()
    }
    
}
