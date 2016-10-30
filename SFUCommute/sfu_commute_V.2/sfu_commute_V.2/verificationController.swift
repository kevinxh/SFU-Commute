//
//  ViewController.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

class VerificationPage: UIViewController {
    
    @IBOutlet var verifyTitle: pageTitle!
    @IBOutlet var verifyTextField: textField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onChange(_ sender: textField) {
        let text = verifyTextField.text!
        let length : Int = text.characters.count
        if (length == 11) {
            verifyTextField.text!.remove(at: text.index(before: text.endIndex))
        }
    }
}

