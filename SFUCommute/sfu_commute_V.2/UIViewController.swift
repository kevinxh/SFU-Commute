//
//  UIViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension UIViewController {
    func setupSideMenuNavButton() {
        let leftBarIconButton = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 24)] as [String: Any]
        leftBarIconButton.setTitleTextAttributes(attributes, for: .normal)
        leftBarIconButton.title = String.fontAwesomeIcon(code: "fa-bars")
        leftBarIconButton.tintColor = UIColor.white
        leftBarIconButton.target = self.revealViewController()
        leftBarIconButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.navigationItem.leftBarButtonItem = leftBarIconButton
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
