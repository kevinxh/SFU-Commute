//
//  customSearchBar.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-09.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit

class customSearchBar: UISearchBar {
    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!

    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        searchBarStyle = UISearchBarStyle.default
        isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i] is UITextField {
                index = i
                break
            }
        }
        return index
    }
    
    override func draw(_ rect: CGRect) {
        if let index = indexOfSearchFieldInSubviews() {
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.height - 10.0)
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            searchField.backgroundColor = barTintColor
        }
        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width,y: frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = preferredTextColor.cgColor
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
        super.draw(rect)
    }
}
