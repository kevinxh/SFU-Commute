//
//  pageTitleView.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-10-28.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit
import Foundation
import FontAwesome_swift

@IBDesignable class pageTitle: UIView {
    var icon: UILabel!
    var title: UILabel!
    var subtitle: UILabel!
    
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
        let height : CGFloat = 100.0
        let width : CGFloat = 100.0
        let iconX = self.frame.width/2 - width/2
        icon = UILabel(frame: CGRect(x: iconX, y: 0, width: width, height: height))
        icon.textAlignment = NSTextAlignment.center
        icon.textColor = Colors.SFURed
        icon.font = UIFont.fontAwesome(ofSize: 110)
        self.addSubview(icon)
    }
    
    func initTitle() {
        title = UILabel(frame: CGRect(x:0, y: icon.frame.size.height, width: self.frame.width, height:100))
        title.textColor = UIColor.black
        title.font = UIFont.boldSystemFont(ofSize: 36.0)
        title.numberOfLines = 0
        title.textAlignment = NSTextAlignment.center
        self.addSubview(title)
    }
    
    func initSubtitle() {
        let width = self.frame.width - 40
        let subtitleX = self.frame.width/2 - width/2
        subtitle = UILabel(frame: CGRect(x:subtitleX, y: icon.frame.size.height + title.frame.size.height, width: width, height:60))
        subtitle.textColor = UIColor.darkGray
        subtitle.font = UIFont.italicSystemFont(ofSize: 16.0)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = NSTextAlignment.center
        self.addSubview(subtitle)
    }
}

