//
//  mapMarkerInfoWindow.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-10.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit
import SwiftyButton

class mapMarkerInfoWindow: UIView {
    
    var leftButton : FlatButton = FlatButton()
    var rightButton : FlatButton = FlatButton()
    var onlyButton : FlatButton = FlatButton()
    var Name : UILabel = UILabel()
    var Zone : UILabel = UILabel() // capitalize first letter because Objective-C conflict
    var Price : UILabel = UILabel()
    var ZoneLabel : UILabel = UILabel() // capitalize first letter because Objective-C conflict
    var PriceLabel : UILabel = UILabel()

    init(frame: CGRect, status: mapViewSteps) {
        super.init(frame: frame)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
        self.VborderColor = UIColor.lightGray
        self.VborderWidth = 1.0
        
        Name.textColor = UIColor.black
        Name.font = UIFont(name: "Futura-Medium", size: 15)!
        Name.numberOfLines = 1
        Name.textAlignment = NSTextAlignment.left
        self.addSubview(Name)
        
        
        Price.textColor = UIColor.black
        Price.font = UIFont(name: "Futura-Medium", size: 15)!
        Price.numberOfLines = 1
        Price.textAlignment = NSTextAlignment.left
        self.addSubview(Price)
        
        
        Zone.textColor = UIColor.black
        Zone.font = UIFont(name: "Futura-Medium", size: 15)!
        Zone.numberOfLines = 1
        Zone.textAlignment = NSTextAlignment.left
        self.addSubview(Zone)
        
        PriceLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        PriceLabel.text = "Suggested Price: $"
        PriceLabel.font = UIFont(name: "Futura-Medium", size: 13)!
        PriceLabel.textAlignment = NSTextAlignment.left
        self.addSubview(PriceLabel)
        
        ZoneLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        ZoneLabel.text = "Zone:"
        ZoneLabel.font = UIFont(name: "Futura-Medium", size: 13)!
        ZoneLabel.textAlignment = NSTextAlignment.left
        self.addSubview(ZoneLabel)
        
        Name.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self)
            make.height.equalTo(self.frame.height/3)
        }
        PriceLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(Price.snp.left).offset(10)
            make.top.equalTo(Name.snp.bottom)
            make.height.equalTo(self.frame.height/3)
            make.width.equalTo(120)
        }
        Price.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(PriceLabel.snp.right).offset(-10)
            make.top.equalTo(Name.snp.bottom)
            make.height.equalTo(self.frame.height/3)
        }
        ZoneLabel.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(Zone.snp.left)
            make.top.equalTo(Name.snp.bottom)
            make.height.equalTo(self.frame.height/3)
        }
        Zone.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(ZoneLabel.snp.right)
            make.top.equalTo(Name.snp.bottom)
            make.height.equalTo(self.frame.height/3)
        }
        
        if (status == .toSetStartLocation) {
            onlyButton.setTitle("Set start location", for: .normal)
            onlyButton.color = Colors.SFURed
            onlyButton.highlightedColor = Colors.SFURedHighlight
            onlyButton.cornerRadius = 0
            onlyButton.titleLabel!.font = UIFont(name: "Futura-Medium", size: 13)!
            self.addSubview(onlyButton)
            onlyButton.snp.makeConstraints{(make) -> Void in
                make.left.right.bottom.equalTo(self)
                make.height.equalTo(self.frame.height/3)
            }
        } else {
            leftButton.setTitle("Start location", for: .normal)
            leftButton.color = Colors.SFURed
            leftButton.highlightedColor = Colors.SFURedHighlight
            leftButton.cornerRadius = 0
            leftButton.titleLabel!.font = UIFont(name: "Futura-Medium", size: 13)!
        
            rightButton.setTitle("Destination", for: .normal)
            rightButton.color = Colors.SFUBlueHighlight
            rightButton.highlightedColor = Colors.SFUBlueLayer
            rightButton.cornerRadius = 0
            rightButton.titleLabel!.font = UIFont(name: "Futura-Medium", size: 13)!
            self.addSubview(leftButton)
            self.addSubview(rightButton)
            leftButton.snp.makeConstraints{(make) -> Void in
                make.left.bottom.equalTo(self)
                make.right.equalTo(rightButton.snp.left)
                make.width.equalTo(rightButton)
                make.height.equalTo(self.frame.height/3)
            }
            rightButton.snp.makeConstraints{(make) -> Void in
                make.right.bottom.equalTo(self)
                make.left.equalTo(leftButton.snp.right)
                make.width.equalTo(leftButton)
                make.height.equalTo(self.frame.height/3)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
