//
//  codeVerificationController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-01.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import SwiftyButton

class codeVerificationController: UIViewController {
    
    var verifyTitle: pageTitle! = pageTitle()
    var button : FlatButton = FlatButton()
    var textFields : UIStackView = UIStackView()
    var code1 : textField = textField()
    var code2 : textField = textField()
    var code3 : textField = textField()
    var code4 : textField = textField()
    
    var phone : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle()
        initButton()
        initTextFields()
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
    
    func initTextFields() {
        textFields = UIStackView(arrangedSubviews: [code1, code2, code3, code4])
        textFields.backgroundColor = Colors.SFURed
        textFields.axis = .horizontal
        textFields.distribution = .equalSpacing
        textFields.alignment = .center
        textFields.spacing = 4
        self.view.addSubview(textFields)
        //code1.font = UIFont
        textFields.addSubview(code1)
        textFields.addSubview(code2)
        textFields.addSubview(code3)
        textFields.addSubview(code4)
        textFields.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.top.greaterThanOrEqualTo(350)
            make.top.lessThanOrEqualTo(425)
            make.left.greaterThanOrEqualTo(self.view).offset(80)
            make.right.greaterThanOrEqualTo(self.view).offset(-80)
            make.centerX.equalTo(self.view)
        }
        code1.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(50)
            //make.top.equalTo(textFields)
            //make.left.greaterThanOrEqualTo(textFields.snp.left)
            //make.right.equalTo(code2.snp.left).offset(-20)
        }
        code2.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(50)
            //make.top.equalTo(textFields)
            //make.left.equalTo(code1.snp.right).offset(20)
            //make.right.equalTo(code3.snp.left).offset(-20)
        }
        code3.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(50)
            //make.top.equalTo(textFields)
            //make.left.equalTo(code2.snp.right).offset(20)
            //make.right.equalTo(code4.snp.left).offset(-20)
        }
        code4.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(50)
            //make.top.equalTo(textFields)
            //make.left.equalTo(code3.snp.right).offset(20)
            //make.right.lessThanOrEqualTo(textFields.snp.right)
        }
    }
    
    @IBAction func verifyTapped(_ sender: FlatButton) {
        print(phone)
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
