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
    let segueIdentifier : String!
    let itemName : String!
    let iconName : String!
}

class sideMenuNavTable: UITableViewController {
    
    var arrayOfNav = [sideMenuItemData]()
    
    @IBOutlet var navTable: UITableView!
    
    override func viewDidLoad() {
        navTable.backgroundColor = UIColor.clear
        arrayOfNav = [sideMenuItemData(cell: 1, segueIdentifier:"showHomeFromSideMenu", itemName: "Home", iconName: "fa-home" ),
                      sideMenuItemData(cell: 2, segueIdentifier:"showBrowseFromSideMenu",itemName: "Browse Trips", iconName: "fa-search" ),
                      /*sideMenuItemData(cell: 3, segueIdentifier:"showUpcomingFromSideMenu",itemName: "Upcoming Trips", iconName: "fa-car" ),
                      sideMenuItemData(cell: 4, segueIdentifier:"showHistoryFromSideMenu",itemName: "History", iconName: "fa-history" ),
                      sideMenuItemData(cell: 5, segueIdentifier:"showMessagesFromSideMenu",itemName: "Messages", iconName: "fa-commenting" ),
                        */
                      sideMenuItemData(cell: 3, segueIdentifier:"showSettingsFromSideMenu",itemName: "Settings", iconName: "fa-cog" )
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNav.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("sideMenuItem", owner: self, options: nil)?.first as! sideMenuItem
        cell.itemName = arrayOfNav[indexPath.row].itemName
        cell.segueIdentifier = arrayOfNav[indexPath.row].segueIdentifier
        cell.iconName = arrayOfNav[indexPath.row].iconName
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(arrayOfNav[indexPath.row].itemName)
        self.performSegue(withIdentifier: self.arrayOfNav[indexPath.row].segueIdentifier, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
    }
    
}
