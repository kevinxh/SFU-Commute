//
//  ViewController.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import FontAwesome_swift

class VerificationPage: UIViewController {
    
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var verifyTitle: UILabel!
    @IBOutlet var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        verifyTitle.font = UIFont.fontAwesome(ofSize: 100)
        verifyTitle.text = String.fontAwesomeIcon(name: .github)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

