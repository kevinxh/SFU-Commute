//
//  addressSearchViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-09.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

struct dataForSearchController{
    var status : mapViewSteps
    var role : role
    var button : Int
}

class addressSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var searchResults: UITableView!
    var searchController: UISearchController!
    var CustomSearchController: customSearchController!
    
    var status : mapViewSteps = .toSetStartLocation
    
    let pre = preDeterminedLocations
    var filteredPre = [location]()
    
    var googlePlaceSearchResult = [GMSAutocompletePrediction!]()

    var shouldShowSearchResults = false
    var role : role = .request
    var triggerButton : Int = 1

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
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(role == .offer) {
            let placeClient = GMSPlacesClient()
            let greatVancouver = GMSCoordinateBounds.init(coordinate: CLLocationCoordinate2DMake(49.411800, -122.210651), coordinate: CLLocationCoordinate2DMake(49.005486, -123.324340))
            
            placeClient.autocompleteQuery(searchText, bounds: greatVancouver, filter: nil, callback: { (places, err) -> Void in
                self.googlePlaceSearchResult.removeAll()
                guard err == nil else {
                    print("Autocomplete error: \(err)")
                    return
                }
                
                for place in places! {
                    self.googlePlaceSearchResult.append(place)
                    self.searchResults.reloadData()
                }
            })
        }
        if(role == .request){
            if(searchBar.text?.characters.count != 0){
                shouldShowSearchResults = true
                searchResults.reloadData()
            } else {
                shouldShowSearchResults = false
                searchResults.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if(role == .request){
            shouldShowSearchResults = false
            searchResults.reloadData()
        }
    }
    
    /*func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            searchResults.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }*/
    
    // MARK: UISearchResultsUpdating functions
    
    func updateSearchResults(for: UISearchController) {
        if(role == .request){
        let searchString = searchController.searchBar.text!
        
        // Filter the data array and get only those items that match the search text.
        filteredPre = pre.filter({ (location) -> Bool in
            let addressText : NSString = location.name as NSString
            return (addressText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        searchResults.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if(role == .request) {
            if shouldShowSearchResults {
                rows = filteredPre.count
            }
            else {
                rows = pre.count
            }
            //for map!
        } else {
            rows = googlePlaceSearchResult.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressSearchResultCells", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Roboto-Regular", size: 18.0)!
        if (role == .request){
            if shouldShowSearchResults {
                cell.textLabel?.text = filteredPre[indexPath.row].name
            }
            else {
                cell.textLabel?.text = pre[indexPath.row].name
            }
        } else {
            cell.textLabel?.text = googlePlaceSearchResult[indexPath.row].attributedFullText.string
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = searchResults.indexPathForSelectedRow?.row
        if (segue.identifier == "unwindToMapViewFromSearch") {
            var locationData = location()
            let locationText = (sender as! UITableViewCell).textLabel?.text!
            let mapview = segue.destination as! MapView
            
            if (triggerButton == 1) {
                if (status == .toSetStartLocation) {
                    mapview.status = .toSetDestination
                }
            } else if (triggerButton == 2) {
                mapview.status = .toTapCreateButton
            }
            if (role == .request){
                locationData = preDeterminedLocations.first(where: {$0.name == locationText})!
                if (triggerButton == 1) {
                    mapview.startLocation = locationData
                } else if (triggerButton == 2) {
                    mapview.destination = locationData
                }
            } else if(role == .offer){
                let placeClient = GMSPlacesClient()
                let placeID = googlePlaceSearchResult[index!].placeID!
                if (triggerButton == 1 ) {
                    placeClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        if let place = place {
                            locationData.name = locationText!
                            locationData.lat = place.coordinate.latitude
                            locationData.lon = place.coordinate.longitude
                            mapview.startLocation = locationData
                            mapview.offerStart.position = place.coordinate
                            mapview.offerStart.appearAnimation = kGMSMarkerAnimationPop
                            mapview.offerStart.icon = UIImage(named: "map-marker-red-128")
                            mapview.offerStart.infoWindowAnchor = CGPoint(x: 0.5, y: -0.5)
                            mapview.offerStart.opacity = 0.95
                            mapview.offerStart.map = mapview.googlemap
                        } else {
                            print("No place details for \(placeID)")
                        }
                    })
                } else if (triggerButton == 2){
                    placeClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        if let place = place {
                            locationData.name = locationText!
                            locationData.lat = place.coordinate.latitude
                            locationData.lon = place.coordinate.longitude
                            mapview.destination = locationData
                            
                            mapview.offerDestination.position = place.coordinate
                            print("set offer destin!")
                            mapview.offerDestination.appearAnimation = kGMSMarkerAnimationPop
                            mapview.offerDestination.icon = UIImage(named: "map-marker-blue-128")
                            mapview.offerDestination.infoWindowAnchor = CGPoint(x: 0.5, y: -0.5)
                            mapview.offerDestination.opacity = 0.95
                            mapview.offerDestination.map = mapview.googlemap
                        } else {
                            print("No place details for \(placeID)")
                        }
                    })
                }
            }
        }
    }
}
