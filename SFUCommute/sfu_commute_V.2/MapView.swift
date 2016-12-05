//
//  MapView.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-30.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import FontAwesome_swift
import SwiftyButton
import GoogleMaps
import DGRunkeeperSwitch
import Alamofire
import SwiftyJSON

enum mapViewSteps {
    case toSetStartLocation
    case toSetDestination
    case toTapCreateButton
}

enum role : String{
    case request
    case offer
}

class MapView: UIViewController, GMSMapViewDelegate {

    var role : role = .request
    var status : mapViewSteps = .toSetStartLocation
    var startLocation : location = location(){
        didSet{
            startLocationLabel.text = startLocation.name
        }
    }
    var destination : location = location(){
        didSet{
            destinationLabel.text = destination.name
        }
    }
    
    // UI
    @IBOutlet var locationBox: UIView!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var mapView: UIView!
    var googlemap : GMSMapView = GMSMapView()
    
    var createTripButton : FlatButton = FlatButton()
    var locationBoxSearchButton: FlatButton! = FlatButton()
    let locationBoxIcon = UILabel()
    let locationBoxLabel = UILabel()
    let startLocationLabel = UILabel()
    var locationBox2 = UIView()
    var locationBox2SearchButton: FlatButton! = FlatButton()
    let locationBoxIcon2 = UILabel()
    let locationBoxLabel2 = UILabel()
    let destinationLabel = UILabel()
    let roleSwitch = DGRunkeeperSwitch(titles: ["Request a ride" , "Offer a ride"])
    
    var offerStart = GMSMarker()
    var offerDestination = GMSMarker()
    var offerRoute = GMSPolyline()
    var emptyMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        initLocationBox()
        initButton()
        initMap()
        initSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (offerStart.position.latitude != emptyMarker.position.latitude && offerDestination.position.latitude == emptyMarker.position.latitude){
            animateStart()
        }
        if (offerStart.position.latitude != emptyMarker.position.latitude && offerDestination.position.latitude != emptyMarker.position.latitude){
            drawRoute()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMap() {
        mapView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(locationBox.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        mapView.clipsToBounds = true
        let camera = GMSCameraPosition.camera(withLatitude: 49.253480, longitude: -122.918631, zoom: 12)
        googlemap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        googlemap.delegate = self
        googlemap.settings.myLocationButton = true
        googlemap.isMyLocationEnabled = true
        // move my location button up
        googlemap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        do {
            if let styleURL = Bundle.main.url(forResource: "style-flat", withExtension: "json") {
                googlemap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("The style definition could not be loaded: \(error)")
        }
        renderPreDeterminedLocations()
        mapView.addSubview(googlemap)
        googlemap.snp.makeConstraints{(make) -> Void in
            make.left.right.top.bottom.equalTo(mapView)
        }
    }
    
    func updateStatus() {
        infoWindow.removeFromSuperview()
        if (status == .toSetStartLocation) {
            self.navigationItem.prompt = "Please search for start location"
        } else if (status == .toSetDestination) {
            appendLocationBox()
            self.navigationItem.prompt = "Please search for destination"
        } else if (status == .toTapCreateButton) {
            self.navigationItem.prompt = nil
        }
        updateButton()
    }
    
    func updateButton() {
        if (startLocation.name.characters.count > 1 && destination.name.characters.count > 1){
            createTripButton.isEnabled = true
        } else {
            createTripButton.isEnabled = false
        }
    }
    
    func animateStart(){
        googlemap.animate(with: GMSCameraUpdate.setTarget(offerStart.position, zoom: 13))
    }
    
    func drawRoute() {
        offerRoute.map = nil
        let parameters : Parameters = [
            "origin": "\(offerStart.position.latitude),\(offerStart.position.longitude)",
            "destination": "\(offerDestination.position.latitude),\(offerDestination.position.longitude)",
            "key": "AIzaSyAJF2MhJpuiPLRB9l_o7Zlp2v9Wj6Hv0rU"
        ]
        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json", method: .get, parameters: parameters).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "OK") {
                    self.offerRoute = GMSPolyline.init(path: GMSPath.init(fromEncodedPath: json["routes"][0]["overview_polyline"]["points"].stringValue))
                    self.offerRoute.strokeColor = Colors.SFUBlue
                    self.offerRoute.strokeWidth = 2.5
                    self.offerRoute.map = self.googlemap
                    self.googlemap.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds.init(path: GMSPath.init(fromEncodedPath: json["routes"][0]["overview_polyline"]["points"].stringValue)!), with: UIEdgeInsetsMake(120, 50, 120, 50)))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func initSwitch(){
        roleSwitch.backgroundColor = Colors.SFUBlue
        roleSwitch.selectedBackgroundColor = .white
        roleSwitch.titleColor = .white
        roleSwitch.selectedTitleColor = Colors.SFUBlue
        roleSwitch.titleFont = UIFont(name: "Futura-Medium", size: 13.0)
        roleSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        roleSwitch.addTarget(self, action: #selector(self.switchRole(_:)), for: .valueChanged)
        navigationItem.titleView = roleSwitch
    }
    
    func renderPreDeterminedLocations() {
        googlemap.clear()
        if (roleSwitch.selectedIndex == 0){
            for location in preDeterminedLocations {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(location.lat, location.lon)
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.icon = UIImage(named: "map-man-red-64")
                marker.userData = location
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: -0.5)
                marker.opacity = 0.8
                marker.map = googlemap
            }
        }
    }
    
    func switchRole(_ sender: Any?){
        startLocation = location()
        destination = location()
        createTripButton.isEnabled = false
        googlemap.clear()
        infoWindow.removeFromSuperview()
        renderPreDeterminedLocations()
        if (role == .request) {
            role = .offer
        } else {
            role = .request
        }
    }
    
    func initLocationBox() {
        // initialize button
        locationBoxSearchButton.tag = 1
        locationBoxSearchButton.setTitle(String.fontAwesomeIcon(code: "fa-search"), for: .normal)
        locationBoxSearchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 32)
        locationBoxSearchButton.color = Colors.SFURed
        locationBoxSearchButton.highlightedColor = Colors.SFURedHighlight
        locationBoxSearchButton.cornerRadius = 10.0
        locationBoxSearchButton.addTarget(self, action: #selector(self.search(_:)), for: .touchUpInside)
        self.locationBox.addSubview(locationBoxSearchButton)
        locationBoxSearchButton.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(locationBox.snp.height).offset(-10)
            make.right.equalTo(locationBox).offset(-10)
            make.centerY.equalTo(locationBox)
        }
        
        // initialize icon
        locationBoxIcon.font = UIFont.fontAwesome(ofSize: 32)
        locationBoxIcon.text = String.fontAwesomeIcon(code: "fa-map-marker")
        locationBoxIcon.textColor = Colors.SFURed
        self.locationBox.addSubview(locationBoxIcon)
        locationBoxIcon.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(locationBox.snp.height).offset(-32)
            make.left.equalTo(locationBox).offset(12)
            make.centerY.equalTo(locationBox)
        }
        
        // initialize label
        locationBoxLabel.text = "START LOCATION"
        locationBoxLabel.textAlignment = .left
        locationBoxLabel.font = UIFont(name: "Futura-Medium", size: 16)!
        locationBoxLabel.textColor = Colors.SFURed
        self.locationBox.addSubview(locationBoxLabel)
        locationBoxLabel.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.left.equalTo(locationBoxIcon.snp.right)
            make.top.equalTo(locationBox)
        }
        
        // initialize label
        startLocationLabel.text = ""
        startLocationLabel.textAlignment = .left
        startLocationLabel.font = UIFont(name: "Futura-Medium", size: 18)!
        startLocationLabel.textColor = UIColor.black
        self.locationBox.addSubview(startLocationLabel)
        startLocationLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(locationBoxIcon.snp.right)
            make.right.equalTo(locationBoxSearchButton.snp.left)
            make.top.equalTo(locationBoxLabel.snp.bottom).offset(-10)
            make.bottom.equalTo(locationBox)
        }
    }
    
    // append second location box programatically
    // the second location box has the same height and background as the first one
    func appendLocationBox(){
        locationBox2 = UIView(frame: CGRect(x: 0, y: locationBox.frame.maxY, width: self.view.frame.width, height: locationBox.frame.height))
        locationBox2.backgroundColor = locationBox.backgroundColor
        locationBox2.bottomBorder = 1.0
        locationBox2.VborderColor = UIColor.darkGray
        self.view.addSubview(locationBox2)
        mapView.snp.remakeConstraints{(make) -> Void in
            make.top.equalTo(locationBox2.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        locationBox2.snp.makeConstraints{(make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(locationBox.snp.bottom)
            make.height.equalTo(locationBox.frame.height)
        }
        
        // initialize button
        locationBox2SearchButton.tag = 2
        locationBox2SearchButton.setTitle(String.fontAwesomeIcon(code: "fa-search"), for: .normal)
        locationBox2SearchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 32)
        locationBox2SearchButton.color = Colors.SFUBlue
        locationBox2SearchButton.highlightedColor = Colors.SFUBlueHighlight
        locationBox2SearchButton.cornerRadius = 10.0
        locationBox2SearchButton.addTarget(self, action: #selector(self.search(_:)), for: .touchUpInside)
        locationBox2.addSubview(locationBox2SearchButton)
        locationBox2SearchButton.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(locationBox2.snp.height).offset(-10)
            make.right.equalTo(locationBox2).offset(-10)
            make.centerY.equalTo(locationBox2)
        }
        
        // initialize icon
        locationBoxIcon2.font = UIFont.fontAwesome(ofSize: 32)
        locationBoxIcon2.text = String.fontAwesomeIcon(code: "fa-map-marker")
        locationBoxIcon2.textColor = Colors.SFUBlue
        locationBox2.addSubview(locationBoxIcon2)
        locationBoxIcon2.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(locationBox2.snp.height).offset(-32)
            make.left.equalTo(locationBox2).offset(12)
            make.centerY.equalTo(locationBox2)
        }
        
        // initialize label
        locationBoxLabel2.text = "DESTINATION"
        locationBoxLabel2.textAlignment = .left
        locationBoxLabel2.font = UIFont(name: "Futura-Medium", size: 16)!
        locationBoxLabel2.textColor = Colors.SFUBlue
        locationBox2.addSubview(locationBoxLabel2)
        locationBoxLabel2.snp.makeConstraints{(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.left.equalTo(locationBoxIcon2.snp.right)
            make.top.equalTo(locationBox2)
        }
        
        // initialize label
        destinationLabel.text = ""
        destinationLabel.textAlignment = .left
        destinationLabel.font = UIFont(name: "Futura-Medium", size: 18)!
        destinationLabel.textColor = UIColor.black
        locationBox2.addSubview(destinationLabel)
        destinationLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(locationBoxIcon2.snp.right)
            make.right.equalTo(locationBox2SearchButton.snp.left)
            make.top.equalTo(locationBoxLabel2.snp.bottom).offset(-10)
            make.bottom.equalTo(locationBox2)
        }
    }
    
    func search(_ sender: Any?) {
        let data = dataForSearchController(status: self.status, role: self.role, button: (sender as! FlatButton).tag)
        self.performSegue(withIdentifier: "showSearchAddress", sender: data)
    }

    func initNavBar() {
        let leftBarIconButton = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 24)] as [String: Any]
        leftBarIconButton.setTitleTextAttributes(attributes, for: .normal)
        leftBarIconButton.title = String.fontAwesomeIcon(code: "fa-bars")
        leftBarIconButton.target = self.revealViewController()
        leftBarIconButton.action = #selector(SWRevealViewController.revealToggle(_:))
        navItem.leftBarButtonItem = leftBarIconButton
        self.mapView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        revealViewController().rearViewRevealWidth = view.frame.width - 80
    }
    
    func initButton() {
        createTripButton.SFURedDefault("Create a trip")
        createTripButton.isEnabled = false
        createTripButton.addTarget(self, action: #selector(self.createBtnTapped(_:)), for: .touchUpInside)
        self.view.addSubview(createTripButton)
        createTripButton.wideBottomConstraints(superview: self.view)
    }
    
    func createBtnTapped(_ sender: Any?) {
        self.performSegue(withIdentifier: "showTripScheduling", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSearchAddress") {
            let data = sender as! dataForSearchController
            let search = segue.destination as! addressSearchViewController
            search.status = data.status
            search.role = data.role
            search.triggerButton = data.button
        } else if (segue.identifier == "showTripScheduling") {
            let tripSchedlue = segue.destination as! tripSchedulingViewController
            tripSchedlue.role = role
            tripSchedlue.startLocation = self.startLocation
            tripSchedlue.destination = self.destination
        } 
        
    }
    
    @IBAction func unwindToMapView(segue: UIStoryboardSegue) { }
    
    // MARK: google map delegate
    
    // initialize and keep a marker
    var tappedMarker = GMSMarker()
    var infoWindow = mapMarkerInfoWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 100), status: .toSetStartLocation)
    
    //empty the default infowindow
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // create custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if (role == .request){
        let location = CLLocationCoordinate2D(latitude: (marker.userData as! location).lat, longitude: (marker.userData as! location).lon)
        
        tappedMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = mapMarkerInfoWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 100), status: self.status)
        infoWindow.Name.text = (marker.userData as! location).name
        infoWindow.Price.text = (marker.userData as! location).price.description
        infoWindow.Zone.text = (marker.userData as! location).zone.rawValue
        infoWindow.center = mapView.projection.point(for: location)
        if (status == .toSetStartLocation) {
            infoWindow.center.y += 80
            infoWindow.onlyButton.addTarget(self, action: #selector(setStartLocation(_:)), for: .touchUpInside)
        } else {
            if (status == .toSetDestination) {
                infoWindow.center.y += 140
            } else {
                infoWindow.center.y += 110
            }
            
            infoWindow.leftButton.addTarget(self, action: #selector(setStartLocation(_:)), for: .touchUpInside)
            infoWindow.rightButton.addTarget(self, action: #selector(setDestination(_:)), for: .touchUpInside)
        }
        self.view.addSubview(infoWindow)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (tappedMarker.userData != nil){
            let location = CLLocationCoordinate2D(latitude: (tappedMarker.userData as! location).lat, longitude: (tappedMarker.userData as! location).lon)
            infoWindow.center = mapView.projection.point(for: location)
            // weird offset
            if (status == .toSetStartLocation) {
                infoWindow.center.y += 80
            } else if (status == .toSetDestination){
                infoWindow.center.y += 140
            } else {
                infoWindow.center.y += 110
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    
    func setStartLocation(_ sender: Any?) {
        startLocation = tappedMarker.userData as! location
        if(status == .toSetStartLocation) {
            status = .toSetDestination
            updateStatus()
        } else {
            infoWindow.removeFromSuperview()
        }
    }
    
    func setDestination(_ sender: Any?) {
        destination = tappedMarker.userData as! location
        if(status == .toSetDestination) {
            status = .toTapCreateButton
            updateStatus()
        } else {
            infoWindow.removeFromSuperview()
        }
    }
}
