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
    
    var goBackButton : UILabel = UILabel()
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
        goBackButton.text = String.fontAwesomeIcon(code: "fa-chevron-left")
        goBackButton.textColor = Colors.SFURed
        goBackButton.font = UIFont.fontAwesome(ofSize: 30)
        let tap : UITapGestureRecognizer = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        goBackButton.addGestureRecognizer(tap)
        goBackButton.isUserInteractionEnabled = true
        tap.addTarget(self, action: #selector(self.goBack(_:)))
        self.view.addSubview(goBackButton)
        goBackButton.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(15)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
        }
        
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.color = Colors.SFURed
        signInButton.highlightedColor = Colors.SFURedHighlight
        signInButton.cornerRadius = 6.0
        //signInButton.isEnabled = false
        signInButton.addTarget(self, action: #selector(self.signInTapped(_:)), for: .touchUpInside)
        self.view.addSubview(signInButton)
        signInButton.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(self.view).offset(-25)
            make.centerX.equalTo(self.view)
        }
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
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.greaterThanOrEqualTo(signInTitle.subtitle.snp.bottom).offset(80)
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
    
    func signInTapped(_ sender: FlatButton) {
        tips.dismiss()
        if (!emailTextField.text!.isValidEmail()) {
            tips = EasyTipView(text: "Invalid Email address")
            tips.show(forView: emailTextField)
        } else if (passwordTextField.text!.characters.count == 0) {
            tips = EasyTipView(text: "Please enter password")
            tips.show(forView: passwordTextField)
        } else {
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
                    //self.performSegue(withIdentifier: "???", sender: self)
                } else {
                    self.tips = EasyTipView(text:json["error"].stringValue)
                    self.tips.show(forView: self.emailTextField)
                }
                
            case .failure(let error):
                print(error)
                self.tips = EasyTipView(text:error.localizedDescription)
                self.tips.show(forView: self.emailTextField)
                
            }
        }
    }
    
    func goBack(_ sender: Any?) {
        self.performSegue(withIdentifier: "unwindToWelcome", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tips.dismiss()
    }

}
