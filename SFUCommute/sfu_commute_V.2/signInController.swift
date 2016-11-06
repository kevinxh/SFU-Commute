//
//  signInController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-04.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyButton
import EasyTipView
import Alamofire
import SwiftyJSON

class signInController: UIViewController {
    
    var backButton : goBackButton! = goBackButton()
    var signInTitle: pageTitle! = pageTitle()
    var emailTextField: textField! = textField()
    var passwordTextField: textField! = textField()
    var signInButton : FlatButton = FlatButton()
    var tips : EasyTipView = EasyTipView(text:"Unknown error occurs.")

    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        initTitle()
        initTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButton() {
        backButton.applyStyle()
        backButton.tap.addTarget(self, action: #selector(self.goBack(_:)))
        self.view.addSubview(backButton)
        backButton.applyConstraints(superview: self.view)
        
        signInButton.SFURedDefault("SIGN IN")
        signInButton.addTarget(self, action: #selector(self.signInTapped(_:)), for: .touchUpInside)
        self.view.addSubview(signInButton)
        signInButton.wideBottomConstraints(superview: self.view)
    }
    
    func initTitle() {
        signInTitle.iconName = "fa-user"
        signInTitle.titleText = "Sign In"
        signInTitle.subtitleText = "Please enter your email and password"
        self.view.addSubview(signInTitle)
        signInTitle.pagePositionConstraints(superview : self.view)
        signInTitle.titleHeight = 50.0
    }
    
    func initTextFields() {
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
            make.top.greaterThanOrEqualTo(signInTitle.subtitle.snp.bottom).offset(30)
        }
        
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
    
    func signInTapped(_ sender: FlatButton) {
        
        // skip the step for dev
        //self.performSegue(withIdentifier: "toMapViewFromSignIn", sender: self)
        tips.dismiss()
        if (!emailTextField.text!.isValidEmail()) {
            tips = EasyTipView(text: "Invalid Email address")
            tips.show(forView: emailTextField)
        } else if (passwordTextField.text!.characters.count == 0) {
            tips = EasyTipView(text: "Please enter password")
            tips.show(forView: passwordTextField)
        } else {
            // avoid multiple requests
            signInButton.isEnabled = false
            sendRequest()
        }
    }
    
    func sendRequest() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let parameters : Parameters = ["email": email, "password": password]
        Alamofire.request(API.signIn(parameters: parameters)).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                // More response parsing, display individual errors
                
                if (json["success"] == true) {
                    AuthorizedRequest.adapter = AccessTokenAdapter(accessToken: json["access_token"].stringValue)
                    self.signInButton.isEnabled = true
                    self.performSegue(withIdentifier: "toMapViewFromSignIn", sender: self)
                } else {
                    self.signInButton.isEnabled = true
                    self.tips = EasyTipView(text:json["error"].stringValue)
                    self.tips.show(forView: self.emailTextField)
                }
                
            case .failure(let error):
                print(error)
                self.signInButton.isEnabled = true
                self.tips = EasyTipView(text:error.localizedDescription)
                self.tips.show(forView: self.emailTextField)
            }
        }.resume()
    }
    
    func goBack(_ sender: Any?) {
        self.performSegue(withIdentifier: "unwindToWelcomeFromSignIn", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tips.dismiss()
    }

}
