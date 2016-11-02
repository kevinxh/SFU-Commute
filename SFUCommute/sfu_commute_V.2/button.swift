//
//  button.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-02.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//
/*
import UIKit
import SwiftyButton

class button: UIView {
    var button : FlatButton = FlatButton()
    
    var fullSize : Bool = true{
        didSet{
            applyConstraints(typical: fullSize)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
        applyConstraints(typical: fullSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
        applyConstraints(typical: fullSize)
    }
    
    func initButton() {
        button.color = Colors.SFURed
        button.highlightedColor = Colors.SFURedHighlight
        button.cornerRadius = 6.0
        self.addSubview(button)
    }

    func applyConstraints(typical: Bool) {
        if (typical == true) {
            self.snp.makeConstraints{(make) -> Void in
                make.width.equalTo(275)
                make.height.equalTo(45)
            }
            
        }
        button.snp.makeConstraints{(make) -> Void in
            make.edges.equalTo(self)
        }
    }

}*/
