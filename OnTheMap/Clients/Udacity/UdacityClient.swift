//
//  UdacityClient.swift
//  On The Map
//
//  Created by Leo Picado on 9/5/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

class UdacityClient:Client {
    let BaseURL = "https://www.udacity.com/api/"
    var sessionId:String?
    var accountKey:String?
    
    // MARK: - GET
    func taskForGETMethod(method: String,
        completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            let urlString = BaseURL + method
            let url = NSURL(string: urlString)!
            let request = NSURLRequest(URL: url)
            
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if let error = downloadError {
                    let newError = Client.errorForData(data, response: response, error: error)
                    completionHandler(result: nil, error: downloadError)
                } else {
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    Client.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
                }
            }
            
            task.resume()
            
            return task
    }
    
    // MARK: - POST
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject],
        completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            let urlString = BaseURL + method
            let url = NSURL(string: urlString)!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            var jsonifyError: NSError? = nil
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
            
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if let error = downloadError {
                    let newError = Client.errorForData(data, response: response, error: error)
                    completionHandler(result: nil, error: downloadError)
                } else {
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    Client.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
                }
            }
            
            task.resume()
            
            return task
    }
    
    // MARK: - DELETE
    func taskForDELETEMethod(method: String,
        completionHandler: (success: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            let urlString = BaseURL + method
            let url = NSURL(string: urlString)!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "DELETE"
            
            // TODO: pass this as additional things within the request
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
                if cookie.name == "XSRF-TOKEN" {
                    xsrfCookie = cookie
                }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if let error = downloadError {
                    let newError = Client.errorForData(data, response: response, error: error)
                    completionHandler(success: false, error: downloadError)
                } else {
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    Client.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
                }
            }
            
            /* 7. Start the request */
            task.resume()
            
            return task
    }
    
    // MARK: - Constants
    
    // Response keys
    struct JSONResponseKeys {
        // MARK: User data
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let EmailObj = "email"
        static let EmailAddress = "address"
        static let Key = "key"
        static let ImageURL = "_image_url"
        static let User = "user"
        
        // MARK: Account
        static let SessionId = "session.id"
        static let SessionExpiration = "session.expiration"
        static let AccountKey = "account.key"
        
        // MARK: Errors
        static let Error = "error"
        static let status = "status"
    }
    
    // Body keys
    struct JSONBodyKeys {
        // MARK: Account
        static let Username = "username"
        static let Password = "password"
        static let Wrapper = "udacity"
    }
    
    // Method names
    struct Methods {
        // MARK: Account related
        static let Session = "session"
        static let PublicData = "users"
    }
    
    // Singleton
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}