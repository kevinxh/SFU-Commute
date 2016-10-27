//
//  File.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation

import UIKit

class SignupPage: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    var emailText = String()
    var passwordText = String()
    var confirmPasswordText = String()
    var phoneNumberText = String()
    var firstNameText = String()
    var lastNameText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: AnyObject) {
        emailText = email.text!
        print(emailText)
        passwordText = password.text!
        print(passwordText)
        confirmPasswordText = confirmPassword.text!
        phoneNumberText = phoneNumber.text!
        firstNameText = firstName.text!
        lastNameText = lastName.text!
    }
    
}
