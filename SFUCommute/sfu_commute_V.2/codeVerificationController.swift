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
    var preferences = EasyTipView.Preferences()
    var textFieldTips = EasyTipView(text:"Error")
    
    var phone : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initTitle()
        initButton()
        initTextFields()
        initTips()
        // Do any additional setup after loading the view.
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
        verifyTitle.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(275)
            make.top.equalTo(self.view).offset(60)
            make.centerX.equalTo(self.view)
        }
        verifyTitle.titleHeight = 50.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textFieldTips.dismiss()
    }
    
    func initButton() {
        button.setTitle("VERIFY", for: .normal)
        button.color = Colors.SFURed
        button.highlightedColor = Colors.SFURedHighlight
        button.cornerRadius = 6.0
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.verifyTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(self.view).offset(-25)
            make.centerX.equalTo(self.view)
        }
        
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
    
    func goBack(_ sender: FlatButton) {
        self.performSegue(withIdentifier: "unwindToVerification", sender: self)
    }
    
    func initTips() {
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = Colors.SFUBlue
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        EasyTipView.globalPreferences = preferences
    }
    
    func initTextFields() {
        textFields = UIStackView(arrangedSubviews: [code1, code2, code3, code4])
        textFields.backgroundColor = Colors.SFURed
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
                //make.top.equalTo(textFields)
                //make.left.greaterThanOrEqualTo(textFields.snp.left)
                //make.right.equalTo(code2.snp.left).offset(-20)
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
        textFieldTips.dismiss()
        
        AuthorizedRequest.request(API.verifyCodeMessage(code: code)).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if (json["success"] == true) {
                    self.textFieldTips = EasyTipView(text:"success", preferences: self.preferences)
                    self.textFieldTips.show(forView: self.textFields)
                    
                    // GO TO NEXT PAGE.
                    
                } else {
                    self.textFieldTips = EasyTipView(text:json["error"].string!, preferences: self.preferences)
                    self.textFieldTips.show(forView: self.textFields)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.textFieldTips = EasyTipView(text:error.localizedDescription, preferences: self.preferences)
                self.textFieldTips.show(forView: self.textFields)
                
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
                textField.borderColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 0.6).cgColor
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
