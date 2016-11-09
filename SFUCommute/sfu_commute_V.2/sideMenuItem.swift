//
//  sideMenuItem.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-05.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

@IBDesignable class sideMenuItem: UITableViewCell {
    
    
    @IBOutlet var icon: UILabel!
    @IBOutlet var sideMenuItemLabel: UILabel!
    var segueIdentifier : String = ""
    
    @IBInspectable var iconName : String! = "fa-awesome"{
        didSet{
            icon.font = UIFont.fontAwesome(ofSize: 30)
            icon.text = String.fontAwesomeIcon(code: iconName)
        }
    }
    
    @IBInspectable var itemName : String! = "Link"{
        didSet{
            sideMenuItemLabel.text = itemName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
