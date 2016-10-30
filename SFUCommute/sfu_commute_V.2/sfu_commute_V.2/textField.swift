//
//  textField.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-10-29.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

@IBDesignable class textField: UITextField {
    
    @IBInspectable var radius : CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable var borderColor : CGColor = UIColor.darkGray.cgColor {
        didSet{
            self.layer.borderColor = borderColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 1.5 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()
    }
    
    func initStyle() {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
    
    /*@IBInspectable var ph: String = "Placeholder" {
        didSet{
            self.placeholder = ph
        }
    }
    
    override init(frame: CGRect) {
        let height : CGFloat = 40.0
        let width : CGFloat = 250.0
        var fixedSize : CGRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
        super.init(frame: fixedSize)
        print(self.frame)
        initStyle()
    }
    
    func initStyle() {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.placeholder = ph
    }*/

}
