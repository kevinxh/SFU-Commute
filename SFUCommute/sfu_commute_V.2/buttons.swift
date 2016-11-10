//
//  buttons.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-04.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import SwiftyButton

extension FlatButton {
    func SFURedDefault(_ title : String) {
        self.setTitle(title, for: .normal)
        self.color = Colors.SFURed
        self.highlightedColor = Colors.SFURedHighlight
        self.cornerRadius = 6.0
        self.titleLabel!.font = UIFont(name: "Futura-Medium", size: 19)!
    }
    
    func wideBottomConstraints(superview : UIView) {
        self.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(superview).offset(40)
            make.right.equalTo(superview).offset(-40)
            make.height.equalTo(45)
            make.bottom.equalTo(superview).offset(-20)
            make.centerX.equalTo(superview)
        }
    }
}
