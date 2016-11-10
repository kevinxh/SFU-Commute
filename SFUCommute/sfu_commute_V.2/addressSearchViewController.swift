//
//  addressSearchViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-09.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit

class addressSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var searchResults: UITableView!
    var searchController: UISearchController!
    var CustomSearchController: customSearchController!
    
    var status : mapViewSteps = .toSetStartLocation
    var dataArray : [String] = ["Burnaby", "Coquitlam"]
    var filteredArray = [String]()
    var shouldShowSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.delegate = self
        searchResults.dataSource = self
        searchResults.reloadData()
        initSearchController()
        //configureCustomSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false
        // text field style of search bar
        for subView in searchController.searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.backgroundColor = Colors.SFUBlue.withAlphaComponent(0.5)
                    textField.attributedPlaceholder = NSAttributedString(string: "Search addresses...", attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
                    textField.textColor = UIColor.white
                    textField.font = UIFont(name: "Futura", size: 16.0)!
                    let icon = textField.leftView as! UIImageView
                    icon.image = icon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    icon.tintColor = UIColor.white
                }
            }
        }
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    /*func configureCustomSearchController() {
        CustomSearchController = customSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: searchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: Colors.SFURed, searchBarTintColor: Colors.SFUBlue)
        CustomSearchController.hidesNavigationBarDuringPresentation = false
        CustomSearchController.search.placeholder = "Search in this awesome bar..."
        self.navigationItem.titleView = CustomSearchController.search
    }*/
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchResults.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchResults.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            searchResults.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: UISearchResultsUpdating functions
    
    func updateSearchResults(for: UISearchController) {
        let searchString = searchController.searchBar.text!
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (address) -> Bool in
            let addressText : NSString = address as NSString
            return (addressText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        searchResults.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressSearchResultCells", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Futura", size: 24.0)!
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((tableView.cellForRow(at: indexPath)?.textLabel?.text)! as String)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToMapViewFromSearch") {
            if (status == .toSetStartLocation) {
                let location = (sender as! UITableViewCell).textLabel?.text
                let mapview = segue.destination as! MapView
                mapview.startLocation.text = location
                mapview.navigationItem.prompt = "Please search for destination"
                mapview.status = .toSetDestination
            }
        }
    }
}
