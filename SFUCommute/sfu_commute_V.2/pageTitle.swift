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
    let iconHeight : CGFloat = 80
    let titleHeight : CGFloat = 100
    
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initIcon()
        initTitle()
        initSubtitle()
    }
    
    func initIcon() {
        icon.textAlignment = NSTextAlignment.center
        icon.textColor = Colors.SFURed
        icon.font = UIFont.fontAwesome(ofSize: 100)
        self.addSubview(icon)
        icon.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(iconHeight)
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    func initTitle() {
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 36.0, weight: 800)
        title.numberOfLines = 0
        title.textAlignment = NSTextAlignment.center
        self.addSubview(title)
        title.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(titleHeight)
            make.width.equalTo(self)
            make.top.equalTo(self).offset(iconHeight)
            make.centerX.equalTo(self)
        }
    }
    
    func initSubtitle() {
        subtitle.textColor = UIColor.darkGray
        subtitle.font = UIFont.italicSystemFont(ofSize: 16.0)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = NSTextAlignment.center
        self.addSubview(subtitle)
        subtitle.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(self).offset(-40)
            make.top.equalTo(self).offset(titleHeight + iconHeight)
            make.centerX.equalTo(self)
        }
    }
}

