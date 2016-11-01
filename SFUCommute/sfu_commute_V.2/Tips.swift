//
//  Tips.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-10-30.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import EasyTipView

var preferences = EasyTipView.Preferences()
preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
preferences.drawing.foregroundColor = UIColor.white
preferences.drawing.backgroundColor = Colors.SFUBlue
preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
EasyTipView.globalPreferences = preferences
