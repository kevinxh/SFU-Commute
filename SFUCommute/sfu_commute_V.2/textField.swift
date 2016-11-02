//
//  textField.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-10-29.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

@IBDesignable class textField: UITextField {
    
    @IBInspectable var radius : CGFloat = 2.0 {
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable var borderColor : CGColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 0.6).cgColor {
        didSet{
            self.layer.borderColor = borderColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 1.6 {
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
        self.textAlignment = .center
        self.font = UIFont(name: "Futura-Medium", size: 22)!
    }
    
    // Change padding of textfield
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
