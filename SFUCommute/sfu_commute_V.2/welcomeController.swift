//
//  welcomeController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-02.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import SwiftyButton

class welcomeController: UIViewController {
    
    var welcomeTitle: pageTitle! = pageTitle()
    var signUpButton : FlatButton = FlatButton()
    var signInButton : FlatButton = FlatButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalConfig.initApplication()
        initBackground()
        initTitle()
        initButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBackground() {
        // gradient color background
        /*let colorTop = Colors.SFURed.withAlphaComponent(0.6).cgColor
        let colorBottom = Colors.SFURed.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)*/
        
        let background = UIImage(named: "background")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    func initTitle() {
        welcomeTitle.iconName = ""
        welcomeTitle.titleText = "WELCOME"
        welcomeTitle.title.textColor = Colors.SFURed
        welcomeTitle.title.font = UIFont(name: "Futura-Medium", size: 52)!
        welcomeTitle.subtitleText = "Start sharing rides with your SFU classmates"
        welcomeTitle.subtitle.textColor = Colors.SFURed.withAlphaComponent(0.8)
        self.view.addSubview(welcomeTitle)
        welcomeTitle.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(275)
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view)
        }
        welcomeTitle.titleHeight = 50.0
    }
    
    func initButton() {
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 19)!
        signInButton.color = UIColor.clear
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 1.5
        signInButton.highlightedColor = UIColor.white.withAlphaComponent(0.5)
        signInButton.layer.cornerRadius = 6.0
        signInButton.addTarget(self, action: #selector(self.signIn(_:)), for: .touchUpInside)
        self.view.addSubview(signInButton)
        signInButton.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(self.view).offset(-25)
            make.centerX.equalTo(self.view)
        }
        
        signUpButton.setTitle("Create an account", for: .normal)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 19)!
        signUpButton.color = UIColor.clear
        signUpButton.layer.backgroundColor = Colors.SFURed.cgColor
        //signUpButton.layer.borderColor = UIColor.white.cgColor
        //signUpButton.layer.borderWidth = 1.5
        signUpButton.highlightedColor = Colors.SFURedHighlight
        signUpButton.layer.cornerRadius = 6.0
        signUpButton.addTarget(self, action: #selector(self.signUp(_:)), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(signInButton).offset(-50)
            make.centerX.equalTo(self.view)
        }
    }
    
    func signUp(_ sebder: Any?) {
        performSegue(withIdentifier: "signup", sender: self)
    }
    
    func signIn(_ sebder: Any?) {
        performSegue(withIdentifier: "signin", sender: self)
    }
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) { }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
