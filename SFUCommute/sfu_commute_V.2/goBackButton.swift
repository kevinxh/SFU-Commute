//
//  goBackButton.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-04.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

class goBackButton: UILabel {
    
    let tap : UITapGestureRecognizer = UITapGestureRecognizer()

    func applyStyle() {
        self.text = String.fontAwesomeIcon(code: "fa-chevron-left")
        self.textColor = Colors.SFURed
        self.font = UIFont.fontAwesome(ofSize: 30)
        self.tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func applyConstraints(superview : UIView) {
        self.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(superview).offset(15)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(superview).offset(30)
        }

    }
}
