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
/*
var maximumSpeed:Double = 0.0


let lineColours = [ UIColor.red,
                    UIColor.orange,
                    UIColor.white,
                    UIColor.green,
                    UIColor.blue
]

extension CLLocation {
    
    func lineColour() -> UIColor{
        let normalisedSpeed = self.speed / maximumSpeed
        if normalisedSpeed < 0.2 {return lineColours[0];}
        else if normalisedSpeed < 0.4 {return lineColours[1];}
        else if normalisedSpeed < 0.6 {return lineColours[2] }
        else if normalisedSpeed < 0.8 {return lineColours[3]}
        else {return lineColours[4]}
    }
    
}

class ColourPolyline: MGLPolyline {
    // Because this is a subclass of MGLPolyline, there is no need to redeclare its properties.
    
    // Custom property that we will use when drawing the polyline.
    var color = UIColor.darkGray
}
extension Double {
    func format(f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
}

enum speedUnit {
    case knotsPerHour
    case metersPerSecond
    case kilometersPerHour
    case milesPerHour
    case feetPerSecond
}

struct SpeedDisplay {
    var metersPerSecond = 0.0
    var kilometersPerHour: Double {
        get {
            return 3.6 * self.metersPerSecond
        }
    }
    var milesPerHour: Double {
        get {
            return 2.23694 * self.metersPerSecond
        }
    }
    var knotsPerHour: Double {
        get {
            return 1.94384 * self.metersPerSecond
        }
    }
    var feetPerSecond: Double {
        get {
            return 3.28084 * self.metersPerSecond
        }
    }
    
    init(speedMetersPerSecond:Double){
        self.metersPerSecond = speedMetersPerSecond
    }
    func speedInUnits(units:speedUnit) -> Double{
        switch units{
        case .metersPerSecond:
            return self.metersPerSecond
        case .feetPerSecond:
            return self.feetPerSecond
        case .kilometersPerHour:
            return self.kilometersPerHour
        case .milesPerHour:
            return self.milesPerHour
        default:
            return 0.0
        }
    }
    func speedInLabel(units:speedUnit) -> String{
        return self.speedInUnits(units: units).format(f: "1")
    }
    
    func labelForUnit(units:speedUnit) -> String{
        switch units{
        case .metersPerSecond:
            return "m/s"
        case .feetPerSecond:
            return "ft/s"
        case .kilometersPerHour:
            return "kph"
        case .milesPerHour:
            return "mph"
        default:
            return ""
        }
    }
}*/

enum mapViewSteps {
    case toSetStartLocation
    case toSetDestination
    case toTapCreateButton
}

class MapView: UIViewController, GMSMapViewDelegate {
    /*
    let manager = CLLocationManager()
    var firstPoint = true
    var lastCoordinate: CLLocation?
    var lastSpeed = SpeedDisplay(speedMetersPerSecond: 0)
    var currentUnits = speedUnit.metersPerSecond
    @IBOutlet weak var header2View: UIView!
    @IBOutlet weak var currentUnitsLabel: UILabel!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    */
 
    
    var status : mapViewSteps = .toSetStartLocation
    
    // UI
    @IBOutlet var locationBox: UIView!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var mapView: UIView!
    var googlemap : GMSMapView = GMSMapView()
    
    var createTripButton : FlatButton = FlatButton()
    var locationBoxSearchButton: FlatButton! = FlatButton()
    let locationBoxIcon = UILabel()
    let locationBoxLabel = UILabel()
    let startLocation = UILabel()
    var locationBox2 = UIView()
    var locationBox2SearchButton: FlatButton! = FlatButton()
    let locationBoxIcon2 = UILabel()
    let locationBoxLabel2 = UILabel()
    let destination = UILabel()
    let roleSwitch = DGRunkeeperSwitch(titles: ["Request a ride", "Offer a ride"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        initLocationBox()
        initButton()
        initMap()
        initSwitch()
        
        //  self.currentUnitsLabel.
        /*self.currentUnitsLabel.text = lastSpeed.labelForUnit(units: self.currentUnits)
         _ = UITapGestureRecognizer(target: self, action: Selector(("tapFunction:")))
         //     tripDetails.addGestureRecognizer(tap)
         self.blurTitleViews()
         self.setupMap()
         self.setupLocationManager()
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateStatus()
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
            createTripButton.isEnabled = true
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
                marker.icon = UIImage(named: "map-marker-pre-location-16")
                marker.userData = location
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: -0.5)
                marker.opacity = 0.8
                marker.map = googlemap
            }
        }
    }
    
    func switchRole(_ sender: Any?){
        googlemap.clear()
        infoWindow.removeFromSuperview()
        renderPreDeterminedLocations()
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
        startLocation.text = ""
        startLocation.textAlignment = .left
        startLocation.font = UIFont(name: "Futura-Medium", size: 20)!
        startLocation.textColor = UIColor.black
        self.locationBox.addSubview(startLocation)
        startLocation.snp.makeConstraints{(make) -> Void in
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
        destination.text = ""
        destination.textAlignment = .left
        destination.font = UIFont(name: "Futura-Medium", size: 20)!
        destination.textColor = UIColor.black
        locationBox2.addSubview(destination)
        destination.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(locationBoxIcon2.snp.right)
            make.right.equalTo(locationBox2SearchButton.snp.left)
            make.top.equalTo(locationBoxLabel2.snp.bottom).offset(-10)
            make.bottom.equalTo(locationBox2)
        }
    }
    
    func search(_ sender: Any?) {
        let data = dataForSearchController(status: self.status, button: (sender as! FlatButton).tag)
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
        //createTripButton.addTarget(self, action: #selector(self.signUpTapped(_:)), for: .touchUpInside)
        self.view.addSubview(createTripButton)
        createTripButton.wideBottomConstraints(superview: self.view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSearchAddress") {
            let data = sender as! dataForSearchController
            let search = segue.destination as! addressSearchViewController
            search.status = data.status
            search.triggerButton = data.button
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
        startLocation.text = (tappedMarker.userData as! location).name
        if(status == .toSetStartLocation) {
            status = .toSetDestination
            updateStatus()
        } else {
            infoWindow.removeFromSuperview()
        }
    }
    
    func setDestination(_ sender: Any?) {
        destination.text = (tappedMarker.userData as! location).name
        if(status == .toSetDestination) {
            status = .toTapCreateButton
            updateStatus()
        } else {
            infoWindow.removeFromSuperview()
        }
    }
    
    /*
    @IBAction func hiDidGetPressed(_ sender: UIButton) {
        print("hi \(mapView)")
    }
    
    
    private func locationManager(manager: CLLocationManager,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            // ...
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if firstPoint {
            lastCoordinate = locations.first!
            mapView.setCenter(locations.last!.coordinate, zoomLevel: 11, animated: true)
            firstPoint = false
        }
        drawPolyline(locations: locations,colour: locations.last!.lineColour())
        lastCoordinate = locations.last!
        lastSpeed = SpeedDisplay(speedMetersPerSecond: locations.last!.speed)
        self.currentSpeedLabel.text = lastSpeed.speedInLabel(units: self.currentUnits)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func setupMap(){
        mapView.delegate = self
        //MGLStyle.darkStyleURL(withVersion: 1)
        mapView.styleURL = MGLStyle.streetsStyleURL(withVersion: 9)
    }
    
    func setupLocationManager(){
        // Do any additional setup after loading the view, typically from a nib.
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }else if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestAlwaysAuthorization()
        }
        manager.delegate = self
        manager.requestLocation()
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    func blurTitleViews(){
        let degrees:Double = -45; //the value in degrees
        let rotation = CGFloat(  degrees * M_PI/180.0)
        
        let rotate = CGAffineTransform(rotationAngle: rotation);
        let translate = CGAffineTransform(translationX: 48, y: 100)
        header2View.transform = translate.concatenating(rotate);
        header2View.clipsToBounds = true
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.header2View.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let header2BlurEffectView = UIVisualEffectView(effect: blurEffect)
            header2BlurEffectView.frame = self.header2View.bounds
            
            header2BlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            self.header2View.insertSubview(header2BlurEffectView, at: 0)
            
        } else {
            self.header2View.backgroundColor = UIColor.black
        }
    }
    func shouldChangeSpeedUnits(){
        
    }
    func drawPolyline(locations: [CLLocation], colour:UIColor) {
        var coordinates:[CLLocationCoordinate2D] = []
        coordinates.append(lastCoordinate!.coordinate)
        
        // Parsing GeoJSON can be CPU intensive, do it on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            for location in locations{
                coordinates.append(location.coordinate)
            }
            let line = ColourPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
            line.color = colour
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.mapView.addAnnotation(line)
            }
        }
        
    }
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        print("Drawing map view")
        if let annotation = annotation as? ColourPolyline {
            // Return orange if the polyline does not have a custom color.
            return annotation.color
        }
        
        // Fallback to the default tint color.
        return mapView.tintColor
    }
    */
}
