//
//  CONFIG.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-04.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import EasyTipView

class Config{
    
    var tipPreferences = EasyTipView.Preferences()

    init(){
        initTip()
    }
    
    func initTip() {
        tipPreferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        tipPreferences.drawing.foregroundColor = UIColor.white
        tipPreferences.drawing.backgroundColor = Colors.SFURedHighlight
        tipPreferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
    }
    
    func initApplication() {
        EasyTipView.globalPreferences = self.tipPreferences
    }
}

var globalConfig = Config()
