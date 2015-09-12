//
//  UdacityMethods.swift
//  On The Map
//
//  Created by Leo Picado on 9/5/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation

// MARK: - Methods for the UdacityClient
extension UdacityClient {
    
    func logInWithUsername(username: String, andPassword:String,
        completionHandler: (success:Bool, errorMessage:String?) -> Void) {
        let params = [
            JSONBodyKeys.Wrapper: [
                JSONBodyKeys.Username: username,
                JSONBodyKeys.Password: andPassword
            ]
        ]
        
        taskForPOSTMethod(Methods.Session, jsonBody: params) {
            (result, error) -> Void in
            if error == nil {
                if let errorMessage = result.valueForKeyPath(JSONResponseKeys.Error) as? String {
                    completionHandler(success: false, errorMessage: errorMessage)
                } else {
                    if let accountKeyString = result.valueForKeyPath(JSONResponseKeys.AccountKey) as? String,
                        sessionId = result.valueForKeyPath(JSONResponseKeys.SessionId) as? String {
                        self.sessionId = sessionId
                        self.accountKey = accountKeyString
                        completionHandler(success: true, errorMessage: nil)
                    } else {
                        completionHandler(success: true, errorMessage: "Could not parse the user's key.")
                    }
                }
            } else {
                completionHandler(success: false, errorMessage: "Error logging in.")
            }
        }
    }
    
    func logOut(completionHandler: (success:Bool, errorMessage:String?) -> Void) {
        taskForDELETEMethod(Methods.Session, completionHandler: { (result, error) -> Void in
            if error == nil {
                if let sessionId = result.valueForKeyPath(UdacityClient.JSONResponseKeys.SessionId) as? String,
                expiration = result.valueForKeyPath(UdacityClient.JSONResponseKeys.SessionExpiration) as? String {
                    completionHandler(success: true, errorMessage: nil)
                    self.sessionId = nil
                    self.accountKey = nil
                } else {
                    completionHandler(success: false, errorMessage: "Incomplete log out process")
                }
            } else {
                completionHandler(success: false, errorMessage: error!.localizedDescription)
            }
        })
    }
    
    func getStudentPublicData(completionHandler: (userInfo:AnyObject?, errorMessage:String?) -> Void) {
        let method = "\(Methods.PublicData)/\(accountKey!)"
        taskForGETMethod(method, completionHandler: { (result, error) -> Void in
            if error == nil {
                if let errorMessage = result.valueForKeyPath(JSONResponseKeys.Error) as? String {
                    completionHandler(userInfo: nil, errorMessage: errorMessage)
                } else {
                    completionHandler(userInfo: result, errorMessage: nil)
                }
            } else {
                completionHandler(userInfo: nil, errorMessage: error?.localizedDescription)
            }
        })
    }
}
