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
    var goBackButton : UILabel = UILabel()
    @IBOutlet var verifyTextField: textField!
    @IBOutlet var phonePrefix: UILabel!
    var textFieldTips = EasyTipView(text:"Your phone number should be 10-digit.")
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
        textFieldTips.dismiss()
        if (length != 0) {
            button.isEnabled = true
        }
        if (length == 10) {
            // if user enters 10 digits, keyboard auto dismiss
            verifyTextField.borderColor = Colors.SFUBlue.cgColor
            verifyTextField.resignFirstResponder()
        }else if (length == 11) {
            verifyTextField.text!.remove(at: text.index(before: text.endIndex))
            textFieldTips = EasyTipView(text:"Your phone number should be 10-digit.")
            textFieldTips.show(forView: verifyTextField)
            // if user enters 10 digits, keyboard auto dismiss
            verifyTextField.resignFirstResponder()
        } else {
            verifyTextField.setDefaultBorderColor()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textFieldTips.dismiss()
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
        self.performSegue(withIdentifier: "goToCodeVerification", sender: self)
        
        if (phone.characters.count != 10) {
            textFieldTips.dismiss()
            textFieldTips = EasyTipView(text:"Your phone number should be 10-digit.")
            textFieldTips.show(forView: verifyTextField)
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
        verifyTitle.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(275)
            make.top.equalTo(self.view).offset(60)
            make.centerX.equalTo(self.view)
        }
    }
    
    func initButton() {
        button.setTitle("SEND", for: .normal)
        button.color = Colors.SFURed
        button.highlightedColor = Colors.SFURedHighlight
        button.isEnabled = false
        button.cornerRadius = 6.0
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
    
    func goBack(_ sender: Any?) {
        // segue back to the last page.. need to be implemented after sign up page
    }


    func sendRequest() {
        // This needs to be done during sign in or sign up!!!
        AuthorizedRequest.adapter = AccessTokenAdapter(accessToken: "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImsuaGU5MzNAZ21haWwuY29tIiwiaWF0IjoxNDc3ODk0NDY3LCJleHAiOjE0ODMwNzg0Njd9.z98bhrHTJR-qtyhqus6w0SB7Of4eynzrYp3imXEaNgg")
        
        let phone = verifyTextField.text!
        let parameters : Parameters = ["phone": "1"+phone]

        AuthorizedRequest.request(API.sendCodeMessage(parameters: parameters)).responseJSON { response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    if (json["success"] == true) {
                        self.performSegue(withIdentifier: "goToCodeVerification", sender: self)
                    } else {
                        self.textFieldTips = EasyTipView(text:json["error"].string!)
                        self.textFieldTips.show(forView: self.verifyTextField)
                    }

                case .failure(let error):
                    print(error)
                    self.textFieldTips = EasyTipView(text:error.localizedDescription)
                    self.textFieldTips.show(forView: self.verifyTextField)

            }
        }
    }

}
