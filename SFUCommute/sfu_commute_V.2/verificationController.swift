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

class VerificationPage: UIViewController {
    
    var verifyTitle: pageTitle! = pageTitle()
    var button : FlatButton = FlatButton()
    @IBOutlet var verifyTextField: textField!
    @IBOutlet var phonePrefix: UILabel!
    var preferences = EasyTipView.Preferences()
    var textFieldTips = EasyTipView(text:"Your phone number should be 10-digit.")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTitle()
        initTextField()
        initTips()
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
        if (length == 11) {
            verifyTextField.text!.remove(at: text.index(before: text.endIndex))
            textFieldTips = EasyTipView(text:"Your phone number should be 10-digit.", preferences: preferences)
            textFieldTips.show(forView: verifyTextField)
            // if user enters 10 digits, keyboard auto dismiss
            verifyTextField.resignFirstResponder()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textFieldTips.dismiss()
    }

    @IBAction func verifyTapped(_ sender: FlatButton) {
        let phone = verifyTextField.text!
        if (phone.characters.count == 1) {
            let vc = codeVerificationController()
            self.present(vc, animated: true, completion: nil)
        }
        
        
        if (phone.characters.count != 10) {
            textFieldTips.dismiss()
            textFieldTips = EasyTipView(text:"Your phone number should be 10-digit.", preferences: preferences)
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
            make.top.greaterThanOrEqualTo(400)
            make.top.lessThanOrEqualTo(500)
        }
        phonePrefix.snp.makeConstraints{(make) -> Void in
            make.centerY.equalTo(verifyTextField)
            make.left.equalTo(self.view).offset(40)
        }
    }
    
    func initTips() {

        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = Colors.SFUBlue
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        EasyTipView.globalPreferences = preferences
    }
    
    func initTitle() {
        verifyTitle.iconName = "fa-mobile"
        verifyTitle.titleText = "Verify your phone number"
        verifyTitle.subtitleText = "SFU Commute will send you an SMS message to verify your phone number."
        self.view.addSubview(verifyTitle)
        verifyTitle.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(275)
            make.top.equalTo(self.view).offset(60)
            make.centerX.equalTo(self.view)
        }
    }
    
    func initButton() {
        button.setTitle("VERIFY", for: .normal)
        button.color = Colors.SFURed
        button.highlightedColor = Colors.SFURedHighlight
        button.cornerRadius = 7.0
        button.addTarget(self, action: #selector(self.verifyTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(self.view).offset(-25)
            make.centerX.equalTo(self.view)
        }
    }

    func sendRequest() {
        // Need an Global object to store access_token
        let headers: HTTPHeaders = [
            "Authorization": "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImsuaGU5MzNAZ21haWwuY29tIiwiaWF0IjoxNDc3ODk0NDY3LCJleHAiOjE0ODMwNzg0Njd9.z98bhrHTJR-qtyhqus6w0SB7Of4eynzrYp3imXEaNgg"
        ]
        let phone = verifyTextField.text!
        let parameters : Parameters = ["phone": "1"+phone]
        Alamofire.request("http://54.69.64.180/verify/text", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    if (json["success"] == true) {
                        let resetToken = json["user"]["phone"]["verification"]["code"]
                        print(resetToken)
                    } else {
                        self.textFieldTips = EasyTipView(text:json["error"].string!, preferences: self.preferences)
                        self.textFieldTips.show(forView: self.verifyTextField)
                    }

                case .failure(let error):
                    self.textFieldTips = EasyTipView(text:error.localizedDescription, preferences: self.preferences)
                    self.textFieldTips.show(forView: self.verifyTextField)

            }
        }
    }

}
