//
//  pageTitleView.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-10-28.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import FontAwesome_swift

@IBDesignable class pageTitle: UIView {
    var icon: UILabel! = UILabel()
    var title: UILabel! = UILabel()
    var subtitle: UILabel! = UILabel()
    
    var iconHeight : CGFloat = 80 {
        didSet{
            updateConstraint()
        }
    }

    var titleHeight : CGFloat = 100 {
        didSet{
            updateConstraint()
        }
    }
    
    @IBInspectable var titleText : String = "Page Title"{
        didSet{
            title.text = titleText
        }
    }
    
    @IBInspectable var subtitleText : String = "Page Subitle"{
        didSet{
            subtitle.text = subtitleText
        }
    }
    
    @IBInspectable var iconName : String = "fa-font-awesome"{
        didSet{
            icon.text = String.fontAwesomeIcon(code: iconName)
        }
    }

    // Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initIcon()
        initTitle()
        initSubtitle()
        applyConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initIcon()
        initTitle()
        initSubtitle()
        applyConstraints()
    }
    
    func initIcon() {
        icon.textAlignment = NSTextAlignment.center
        icon.textColor = Colors.SFURed
        icon.font = UIFont.fontAwesome(ofSize: 90)
        self.addSubview(icon)
        
    }
    
    func initTitle() {
        title.textColor = UIColor.black
        // title.font = UIFont.systemFont(ofSize: 36.0, weight: 800)
        title.font = UIFont(name: "Futura-Bold", size: 36)!
        title.numberOfLines = 0
        title.textAlignment = NSTextAlignment.center
        self.addSubview(title)
        
    }
    
    func initSubtitle() {
        subtitle.textColor = UIColor.darkGray
        subtitle.font = UIFont(name: "Futura-Medium", size: 16)!
        subtitle.numberOfLines = 0
        subtitle.textAlignment = NSTextAlignment.center
        self.addSubview(subtitle)
    }
    
    func applyConstraints() {
        icon.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(iconHeight)
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        title.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(titleHeight)
            make.width.equalTo(self)
            make.top.equalTo(self).offset(iconHeight)
            make.centerX.equalTo(self)
        }
        subtitle.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(self).offset(-40)
            make.top.equalTo(self).offset(titleHeight + iconHeight)
            make.centerX.equalTo(self)
        }
    }
    
    func updateConstraint() {
        icon.snp.updateConstraints{(make) -> Void in
            make.height.equalTo(iconHeight)
        }
        title.snp.updateConstraints{(make) -> Void in
            make.height.equalTo(titleHeight)
            make.top.equalTo(self).offset(iconHeight)
        }
        subtitle.snp.updateConstraints{(make) -> Void in
            make.top.equalTo(self).offset(titleHeight + iconHeight)
        }
    }
    
    func pagePositionConstraints(superview : UIView) {
        self.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(275)
            make.top.equalTo(superview).offset(60)
            make.centerX.equalTo(superview)
        }
    }
}

