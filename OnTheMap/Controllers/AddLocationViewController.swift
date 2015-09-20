//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Leo Picado on 9/19/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var findButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.locationTextField.text.isEmpty {
            return false
        } else {
            textField.resignFirstResponder()
            tapOnFindButton()
            return true
        }
    }
    
    @IBAction func tapOnFindButton() {
        println("GO! \(self.locationTextField.text)")
    }
    
}
