//
//  ParseClient
//  On The Map
//
//  Mostly boilerplate code meant to interact with the Parse API.
//

import Foundation

class ParseClient:Client {
    
    let baseURL = "https://api.parse.com/"
    
    func getBaseNSURLRequest(method:String, httpMethod:String = HTTPMethods.GET) -> NSMutableURLRequest {
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
    
    struct JSONResponseKeys {
        // PFObject
        static let ObjectId = "objectId"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
        // Location retrieval
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let UniqueKey = "uniqueKey"
    }
    
    // Singleton
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
