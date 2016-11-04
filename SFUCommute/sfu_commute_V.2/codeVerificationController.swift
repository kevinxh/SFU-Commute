//
//  codeVerificationController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-01.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import SwiftyButton
import Alamofire
import EasyTipView
import SwiftyJSON

class codeVerificationController: UIViewController {
    
    var verifyTitle: pageTitle! = pageTitle()
    var button : FlatButton = FlatButton()
    var textFields : UIStackView = UIStackView()
    var goBackButton : UILabel = UILabel()
    var code1 : textField = textField()
    var code2 : textField = textField()
    var code3 : textField = textField()
    var code4 : textField = textField()
    var tips : EasyTipView = EasyTipView(text:"Unknown error occurs.")
    var phone : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initTitle()
        initButton()
        initTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTitle() {
        verifyTitle.iconName = "fa-mobile"
        verifyTitle.titleText = "Enter code"
        verifyTitle.subtitleText = "Step 2: A text message with verification code has sent to phone:\n +1 " + phone
        self.view.addSubview(verifyTitle)
        verifyTitle.pagePositionConstraints(superview : self.view)
        verifyTitle.titleHeight = 50.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tips.dismiss()
    }
    
    func initButton() {
        button.SFURedDefault("VERIFY")
        button.addTarget(self, action: #selector(self.verifyTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.wideBottomConstraints(superview: self.view)
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
    }
    
    func goBack(_ sender: Any?) {
        self.performSegue(withIdentifier: "unwindToVerification", sender: self)
    }
    
    func initTextFields() {
        textFields = UIStackView(arrangedSubviews: [code1, code2, code3, code4])
        textFields.axis = .horizontal
        textFields.distribution = .equalSpacing
        textFields.alignment = .center
        textFields.spacing = 4
        self.view.addSubview(textFields)
        
        code1.tag = 1
        code2.tag = 2
        code3.tag = 3
        code4.tag = 4
        
        for index in 1...4 {
            let textField = self.view.viewWithTag(index) as! textField
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.textFieldTapped(_:)), for: .touchDown)
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
            textFields.addSubview(textField)
            textField.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
        }
        
        textFields.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.top.greaterThanOrEqualTo(350)
            make.top.lessThanOrEqualTo(425)
            make.left.greaterThanOrEqualTo(self.view).offset(80)
            make.right.greaterThanOrEqualTo(self.view).offset(-80)
            make.centerX.equalTo(self.view)
        }
    }
    
    func verifyTapped(_ sender: FlatButton) {
        let text1 = code1.text!
        let text2 = code2.text!
        let text3 = code3.text!
        let text4 = code4.text!
        let code = text1 + text2 + text3 + text4
        tips.dismiss()
        
        AuthorizedRequest.request(API.verifyCodeMessage(code: code)).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if (json["success"] == true) {
                    self.tips = EasyTipView(text:"success")
                    self.tips.show(forView: self.textFields)
                    
                    // GO TO NEXT PAGE.
                    
                } else {
                    self.tips = EasyTipView(text:json["error"].string!)
                    self.tips.show(forView: self.textFields)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.tips = EasyTipView(text:error.localizedDescription)
                self.tips.show(forView: self.textFields)
                
            }
        }
    }
    
    
    func textFieldTapped(_ sender: textField) {
        textFieldControl()
    }
    
    func textFieldChanged(_ sender: textField) {
        textFieldControl()
        
    }
    
    func textFieldControl() {
        if (code4.text!.characters.count == 1) {
            code4.resignFirstResponder()
            code4.borderColor = Colors.SFUBlue.cgColor
        } else if (code3.text!.characters.count == 1){
            code1.resignFirstResponder()
            code2.resignFirstResponder()
            code3.resignFirstResponder()
            code4.becomeFirstResponder()
            code3.borderColor = Colors.SFUBlue.cgColor
        } else if (code2.text!.characters.count == 1) {
            
            code1.resignFirstResponder()
            code2.resignFirstResponder()
            code4.resignFirstResponder()
            code3.becomeFirstResponder()
            
        } else if (code1.text!.characters.count == 1) {
            
            code1.resignFirstResponder()
            code3.resignFirstResponder()
            code4.resignFirstResponder()
            code2.becomeFirstResponder()
            
        } else {
            code2.resignFirstResponder()
            code3.resignFirstResponder()
            code4.resignFirstResponder()
            code1.becomeFirstResponder()
        }
        
        for index in 1...4 {
            let textField = self.view.viewWithTag(index) as! textField
            if (textField.text!.characters.count == 0) {
                textField.setDefaultBorderColor()
            } else {
                textField.borderColor = Colors.SFUBlue.cgColor
            }
        }
        
        let text1 = code1.text!
        let text2 = code2.text!
        let text3 = code3.text!
        let text4 = code4.text!
        
        if (text1.characters.count == 1 && text2.characters.count == 1 && text3.characters.count == 1 && text4.characters.count == 1) {
            button.isEnabled = true
        }
    }
}
