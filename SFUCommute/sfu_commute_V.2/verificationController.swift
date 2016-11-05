//
//  ViewController.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import SwiftyButton
import EasyTipView
import Alamofire
import SwiftyJSON
import FontAwesome_swift

class VerificationPage: UIViewController {
    
    var verifyTitle: pageTitle! = pageTitle()
    var button : FlatButton = FlatButton()
    var backButton : goBackButton = goBackButton()
    @IBOutlet var verifyTextField: textField!
    @IBOutlet var phonePrefix: UILabel!
    var tips : EasyTipView = EasyTipView(text:"Unknown error occurs.")
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle()
        initTextField()
        initButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onChange(_ sender: textField) {
        let text = verifyTextField.text!
        let length : Int = text.characters.count
        tips.dismiss()
        if (length != 0) {
            button.isEnabled = true
        }
        if (length == 10) {
            // if user enters 10 digits, keyboard auto dismiss
            verifyTextField.borderColor = Colors.SFUBlue.cgColor
            verifyTextField.resignFirstResponder()
        }else if (length == 11) {
            verifyTextField.text!.remove(at: text.index(before: text.endIndex))
            tips = EasyTipView(text:"Your phone number should be 10-digit.")
            tips.show(forView: verifyTextField)
            // if user enters 10 digits, keyboard auto dismiss
            verifyTextField.resignFirstResponder()
        } else {
            verifyTextField.setDefaultBorderColor()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tips.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCodeVerification" {
            let vc = segue.destination as! codeVerificationController
            vc.phone = verifyTextField.text
        }
    }
    
    // This function is needed to be referenced by storyboard segue
    @IBAction func unwindToVerification(segue: UIStoryboardSegue) { }

    @IBAction func verifyTapped(_ sender: FlatButton) {
        let phone = verifyTextField.text!
        
        // temporarily skip texting step, save some money LOL     --Kevin
        //self.performSegue(withIdentifier: "goToCodeVerification", sender: self)
        
        tips.dismiss()
        if (phone.characters.count != 10) {
            tips = EasyTipView(text:"Your phone number should be 10-digit.")
            tips.show(forView: verifyTextField)
        } else {
            sendRequest()
        }
    }

    func initTextField() {
        verifyTextField.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(phonePrefix.snp.right).offset(8)
            make.right.equalTo(self.view).offset(-40)
            make.top.greaterThanOrEqualTo(350)
            make.top.lessThanOrEqualTo(425)
        }
        phonePrefix.snp.makeConstraints{(make) -> Void in
            make.centerY.equalTo(verifyTextField)
            make.left.equalTo(self.view).offset(40)
        }
    }
    
    func initTitle() {
        verifyTitle.iconName = "fa-mobile"
        verifyTitle.titleText = "Verify your phone number"
        verifyTitle.subtitleText = "Step 1: SFU Commute will send you an SMS message to verify your phone number."
        self.view.addSubview(verifyTitle)
        verifyTitle.pagePositionConstraints(superview : self.view)
    }
    
    func initButton() {
        button.SFURedDefault("SEND")
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.verifyTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.wideBottomConstraints(superview: self.view)
        
        backButton.applyStyle()
        backButton.tap.addTarget(self, action: #selector(self.goBack(_:)))
        self.view.addSubview(backButton)
        backButton.applyConstraints(superview: self.view)
    }
    
    func goBack(_ sender: Any?) {
        self.performSegue(withIdentifier: "unwindToSignUp", sender: self)
    }

    func sendRequest() {
        let phone = verifyTextField.text!
        let parameters : Parameters = ["phone": "1"+phone]

        AuthorizedRequest.request(API.sendCodeMessage(parameters: parameters)).responseJSON { response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    if (json["success"] == true) {
                        self.performSegue(withIdentifier: "goToCodeVerification", sender: self)
                    } else {
                        self.tips = EasyTipView(text:json["error"].stringValue)
                        self.tips.show(forView: self.verifyTextField)
                    }

                case .failure(let error):
                    print(error)
                    self.tips = EasyTipView(text:error.localizedDescription)
                    self.tips.show(forView: self.verifyTextField)

            }
        }
    }

}
