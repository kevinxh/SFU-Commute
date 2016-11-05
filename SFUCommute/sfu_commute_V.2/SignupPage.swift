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

class SignupPage: UIViewController {
    
    var signUpTitle: pageTitle! = pageTitle()
    var backButton : goBackButton = goBackButton()
    var signUpButton : FlatButton = FlatButton()
    var emailTextField: textField! = textField()
    var passwordTextField: textField! = textField()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var registerUI: UIButton!
    var preferences = EasyTipView.Preferences()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text           = "email"
        password.text        = "password"
        confirmPassword.text = "confirm password"
        phoneNumber.text     = "phone number"
        firstName.text       = "first name"
        lastName.text        = "last name"
        initTips()
        initTitle()
        initButton()
        initTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initTips() {
        preferences.drawing.font            = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = Colors.SFUBlue
        preferences.drawing.arrowPosition   = EasyTipView.ArrowPosition.bottom
        EasyTipView.globalPreferences       = preferences
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
        signUpButton.addTarget(self, action: #selector(self.register(_:)), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        signUpButton.wideBottomConstraints(superview: self.view)
    }
    
    func initTextFields() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.placeholder = "Email"
        emailTextField.addTarget(self, action: #selector(self.emailChanged(_:)), for: .editingChanged)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.greaterThanOrEqualTo(signUpTitle.subtitle.snp.bottom).offset(50)
        }
        
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.addTarget(self, action: #selector(self.passwordChanged(_:)), for: .editingChanged)
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
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
        if (passwordTextField.text!.characters.count > 0) {
            passwordTextField.borderColor = Colors.SFUBlue.cgColor
        } else {
            passwordTextField.setDefaultBorderColor()
        }
    }
    
    func goBack(_ sender: Any?) {
        self.performSegue(withIdentifier: "unwindToWelcomeFromSignUp", sender: self)
    }
    
    func forData() {
        let emailText     =  String(email.text!)
        let passwordText  =  String(password.text!)
        let firstNameText =  String(firstName.text!)
        let lastNameText  =  String(lastName.text!)
        
        if let url = URL(string: "http://54.69.64.180/signup") {
            var request        = URLRequest(url: url)
            request.httpMethod = "POST"
            var postString     = "{\"email\": \""
            postString        += emailText!
            postString        += "\", \"password\": \""
            postString        += passwordText!
            postString        += "\", \"firstname\" : \"" + firstNameText!
            postString        += "\", \"lastname\":\"" + lastNameText! + "\"}"
            request.httpBody   = postString.data(using: .utf8)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-type")
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, body) in
                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(json)
                //print(json["error"])
                let dict    = json as? NSDictionary
                let success = String(describing: dict!["success"])
                //let boolValue = Bool(success)
                print("bool value is causing problem:----?")
                print(success)
                if (success == "Optional(1)"){
                    print("was i even here at all")
                    let access_key = String(describing: dict!["access_token"])
                    AuthorizedRequest.adapter = AccessTokenAdapter.init(accessToken: access_key)
                    print(access_key)
                    self.shouldPerformSegue(withIdentifier: "VerificationPage", sender: self)
                    
                }
                else{
                    //DispatchQueue.main.async(){
                    print("I am here now!!!!! Error Time....")
                    //let errmsg = String(describing: dict!["errmsg"])
                    //print(errmsg)
                    let textFieldTips = EasyTipView(text: ("Sign up failed"), preferences: self.preferences)
                    textFieldTips.dismiss()
                    textFieldTips.show(forView: self.registerUI!)
                    //textFieldTips.dismiss()
                    //}
                }
            }).resume()
        }
    }
    
    @IBAction func register(_ sender: AnyObject) {
        let enteredPassword       = password.text!
        let enteredCofirmPassword = confirmPassword.text!
        let textFieldTips         = EasyTipView(text: "The password and confirm password field did not match", preferences: preferences)
        if (enteredPassword      != enteredCofirmPassword) {
            print("I am here!!!!!!!!!!!!!!!!!!!!!!!!!!")
            //textFieldTips.dismiss()
            textFieldTips.show(forView: password)
            //textFieldTips.dismiss()
            //'self.viewDidLoad()
        }
        else {
            forData()
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        let CurrentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(CurrentViewController!, animated: true)
    }
}
