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
    @IBOutlet var signOutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserInfo()
        initSignOut()
    }
    
    func initUserInfo(){
        userImage.layer.cornerRadius = 50
        userImage.layer.borderWidth = 3.0
        userImage.layer.borderColor = Colors.SFUBlue.cgColor
    }
    
    func initSignOut(){
        signOutIcon.font = UIFont.fontAwesome(ofSize: 30)
        signOutIcon.textColor = UIColor.white
        signOutIcon.text = String.fontAwesomeIcon(code: "fa-sign-out")
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(self.signOut(_:)))
        signOutView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOut(_ sender: Any?) {
        // TO DO: release all user data!
        
        //this segue is modally, need to be changed in future!
        self.performSegue(withIdentifier: "toWelcomeFromSideMenuSignOut", sender: self)
    }
}
