//
//  File.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import UIKit
import EasyTipView
import Alamofire
import SwiftyButton
import SwiftyJSON

class SignupPage: UIViewController {
    
    var signUpTitle: pageTitle! = pageTitle()
    var backButton : goBackButton = goBackButton()
    var signUpButton : FlatButton = FlatButton()
    var emailTextField: textField! = textField()
    var passwordTextField: textField! = textField()
    var repeatPasswordTextField: textField! = textField()
    var firstNameTextField: textField! = textField()
    var lastNameTextField: textField! = textField()
    var tips : EasyTipView = EasyTipView(text:"Unknown error occurs.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle()
        initButton()
        initTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tips.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initTitle() {
        signUpTitle.iconName = "fa-user"
        signUpTitle.titleText = "Sign Up"
        signUpTitle.subtitleText = "Please enter the following information"
        self.view.addSubview(signUpTitle)
        signUpTitle.pagePositionConstraints(superview : self.view)
        signUpTitle.titleHeight = 50.0
    }
    
    func initButton() {
        backButton.applyStyle()
        backButton.tap.addTarget(self, action: #selector(self.goBack(_:)))
        self.view.addSubview(backButton)
        backButton.applyConstraints(superview: self.view)
        
        signUpButton.SFURedDefault("SIGN UP")
        signUpButton.addTarget(self, action: #selector(self.signUpTapped(_:)), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        signUpButton.wideBottomConstraints(superview: self.view)
    }
    
    func initTextFields() {
        // Email field
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.placeholder = "Email"
        emailTextField.addTarget(self, action: #selector(self.emailChanged(_:)), for: .editingChanged)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.greaterThanOrEqualTo(signUpTitle.subtitle.snp.bottom).offset(30)
        }
        
        // Password field
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.addTarget(self, action: #selector(self.passwordChanged(_:)), for: .editingChanged)
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
        }
        
        // Repeat password field
        repeatPasswordTextField.keyboardType = .default
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.placeholder = "Repeat password"
        repeatPasswordTextField.addTarget(self, action: #selector(self.repeatPasswordChanged(_:)), for: .editingChanged)
        view.addSubview(repeatPasswordTextField)
        repeatPasswordTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        // first name field
        firstNameTextField.keyboardType = .namePhonePad
        firstNameTextField.placeholder = "First name"
        firstNameTextField.addTarget(self, action: #selector(self.firstNameChanged(_:)), for: .editingChanged)
        view.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(10)
        }
        
        // last name field
        lastNameTextField.keyboardType = .namePhonePad
        lastNameTextField.placeholder = "Last name"
        lastNameTextField.addTarget(self, action: #selector(self.lastNameChanged(_:)), for: .editingChanged)
        view.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(10)
        }
    }
    
    func emailChanged(_ sender: textField) {
        if (emailTextField.text!.isValidEmail()) {
            emailTextField.borderColor = Colors.SFUBlue.cgColor
        } else {
            emailTextField.setDefaultBorderColor()
        }
    }
    
    func passwordChanged(_ sender: textField) {
        if (passwordTextField.text!.isNotEmpty()) {
            passwordTextField.borderColor = Colors.SFUBlue.cgColor
        } else {
            passwordTextField.setDefaultBorderColor()
        }
    }
    
    func repeatPasswordChanged(_ sender: textField) {
        if (repeatPasswordTextField.text!.isNotEmpty() && repeatPasswordTextField.text! == passwordTextField.text!) {
            repeatPasswordTextField.borderColor = Colors.SFUBlue.cgColor
        } else {
            repeatPasswordTextField.setDefaultBorderColor()
        }
    }
    
    func lastNameChanged(_ sender: textField) {
        if (lastNameTextField.text!.isName()) {
            lastNameTextField.borderColor = Colors.SFUBlue.cgColor
        } else {
            lastNameTextField.setDefaultBorderColor()
        }
    }
    
    func firstNameChanged(_ sender: textField) {
        if (firstNameTextField.text!.isName()) {
            firstNameTextField.borderColor = Colors.SFUBlue.cgColor
        } else {
            firstNameTextField.setDefaultBorderColor()
        }
    }
    
    func signUpTapped(_ sender: FlatButton) {
        tips.dismiss()
        if (!emailTextField.text!.isValidEmail()) {
            tips = EasyTipView(text: "Invalid Email address")
            tips.show(forView: emailTextField)
        } else if (passwordTextField.text!.characters.count < 6) {
            tips = EasyTipView(text: "Password should be 6-15 digits")
            tips.show(forView: passwordTextField)
        } else if(passwordTextField.text! != repeatPasswordTextField.text!) {
            tips = EasyTipView(text: "Passwords do not match")
            tips.show(forView: repeatPasswordTextField)
        } else if(!firstNameTextField.text!.isName()) {
            tips = EasyTipView(text: "Invalid first name")
            tips.show(forView: firstNameTextField)
        } else if(!lastNameTextField.text!.isName()) {
            tips = EasyTipView(text: "Invalid last name")
            tips.show(forView: lastNameTextField)
        } else {
            signUpButton.isEnabled = false
            sendRequest()
            print("yes!!")
        }
    }
    
    func sendRequest() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let parameters : Parameters = [
            "email": email,
            "password": password,
            "firstname": firstName,
            "lastname": lastName
        ]
        Alamofire.request(API.signUp(parameters: parameters)).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                if (json["success"] == true) {
                    print("success")
                    AuthorizedRequest.adapter = AccessTokenAdapter(accessToken: json["access_token"].stringValue)
                    self.performSegue(withIdentifier: "toVerification", sender: self)
                } else {
                    
                    // to do: error handling!
                    self.signUpButton.isEnabled = true
                    self.tips = EasyTipView(text:"Error occured, please try again later")
                    self.tips.show(forView: self.emailTextField)
                }
                
            case .failure(let error):
                print(error)
                self.signUpButton.isEnabled = true
                self.tips = EasyTipView(text:error.localizedDescription)
                self.tips.show(forView: self.emailTextField)
                
            }
        }.resume()
    }
    
    @IBAction func unwindToSignUp(segue: UIStoryboardSegue) {}
    
    func goBack(_ sender: Any?) {
        self.performSegue(withIdentifier: "unwindToWelcomeFromSignUp", sender: self)
    }
}
