//
//  navBar.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-05.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

@IBDesignable class navBar: UINavigationBar {
    
    @IBInspectable var barColor: UIColor? = Colors.darkBlueGrey {
        didSet{
            self.barTintColor = barTintColor
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
