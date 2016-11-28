//
//  browseTabBarController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-26.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit

class browseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenuNavButton()
        // Do any additional setup after loading the view.
        
        /*let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let offer = browseViewController(collectionViewLayout: layout)
        let request = browseViewController(collectionViewLayout: layout)
        
        let offerTabBarItem = UITabBarItem(title: "Offer", image: UIImage.fontAwesomeIcon(name: .car, textColor: UIColor.black, size: CGSize(width: 30, height: 30)), selectedImage: UIImage.fontAwesomeIcon(name: .car, textColor: UIColor.red, size: CGSize(width: 30, height: 30)))
        
        let requestTabBarItem = UITabBarItem(title: "Request", image: UIImage.fontAwesomeIcon(name: .child, textColor: UIColor.black, size: CGSize(width: 30, height: 30)), selectedImage: UIImage.fontAwesomeIcon(name: .child, textColor: UIColor.red, size: CGSize(width: 30, height: 30)))
        
        offer.tabBarItem = offerTabBarItem
        request.tabBarItem = requestTabBarItem
        viewControllers = [offer, request]*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
