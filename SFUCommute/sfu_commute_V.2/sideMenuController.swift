//
//  sideMenuController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-05.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

class sideMenuController: UIViewController {

    @IBOutlet var userInfo: UIView!
    @IBOutlet var sideMenuNavContainer: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var signOutIcon: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserInfo()
        initSignOutIcon()
    }
    
    func initUserInfo(){
        userImage.layer.cornerRadius = 50
        userImage.layer.borderWidth = 3.0
        userImage.layer.borderColor = Colors.SFUBlue.cgColor
    }
    
    func initSignOutIcon(){
        signOutIcon.font = UIFont.fontAwesome(ofSize: 30)
        signOutIcon.textColor = UIColor.white
        signOutIcon.text = String.fontAwesomeIcon(code: "fa-sign-out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
