//
//  sideMenu.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-05.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import UIKit

struct sideMenuItemData {
    let cell : Int!
    let itemName : String!
    let iconName : String!
}

class sideMenu: UITableViewController {
    
    var arrayOfNav = [sideMenuItemData]()
    
    @IBOutlet var navTable: UITableView!
    
    override func viewDidLoad() {
        navTable.backgroundColor = Colors.darkBlueGrey
        arrayOfNav = [sideMenuItemData(cell: 1, itemName: "Home", iconName: "fa-home" ),
                      sideMenuItemData(cell: 2, itemName: "Browse", iconName: "fa-bars" ),
                      sideMenuItemData(cell: 3, itemName: "History", iconName: "fa-history" ),
            sideMenuItemData(cell: 4, itemName: "My Rides", iconName: "fa-car" ),
            sideMenuItemData(cell: 5, itemName: "Messages", iconName: "fa-commenting" ),
            sideMenuItemData(cell: 6, itemName: "Settings", iconName: "fa-cog" )
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNav.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("sideMenuItem", owner: self, options: nil)?.first as! sideMenuItem
        cell.itemName = arrayOfNav[indexPath.row].itemName
        cell.iconName = arrayOfNav[indexPath.row].iconName
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
    }

}
