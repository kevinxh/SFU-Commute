//
//  MapView.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-30.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import CoreLocation
//import SideMenu
import FontAwesome_swift
import SwiftyButton

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
}



class MapView: UIViewController, CLLocationManagerDelegate,MGLMapViewDelegate {
    
    let manager = CLLocationManager()
    var firstPoint = true
    var lastCoordinate: CLLocation?
    var lastSpeed = SpeedDisplay(speedMetersPerSecond: 0)
    var currentUnits = speedUnit.metersPerSecond
    
    // UI
    @IBOutlet var locationBox: UIView!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var header2View: UIView!
    @IBOutlet weak var currentUnitsLabel: UILabel!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    var locationBoxSearchButton: FlatButton! = FlatButton()
    let locationBoxIcon = UILabel()
    let locationBoxLabel = UILabel()
    
    @IBAction func hiDidGetPressed(_ sender: UIButton) {
        print("hi \(mapView)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        initLocationBox()
        //  self.currentUnitsLabel.
        self.currentUnitsLabel.text = lastSpeed.labelForUnit(units: self.currentUnits)
        _ = UITapGestureRecognizer(target: self, action: Selector(("tapFunction:")))
        //     tripDetails.addGestureRecognizer(tap)
        self.blurTitleViews()
        self.setupMap()
        self.setupLocationManager()
    }
    
    func initLocationBox() {
        // initialize button
        locationBoxSearchButton.setTitle(String.fontAwesomeIcon(code: "fa-search"), for: .normal)
        locationBoxSearchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 32)
        locationBoxSearchButton.color = Colors.SFURed
        locationBoxSearchButton.highlightedColor = Colors.SFURedHighlight
        locationBoxSearchButton.cornerRadius = 10.0
        locationBoxSearchButton.addTarget(self, action: #selector(self.searchStartPoint(_:)), for: .touchUpInside)
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
    }
    
    func searchStartPoint(_ sebder: Any?) {
        self.performSegue(withIdentifier: "showSearchAddress", sender: nil)
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
    
    private func locationManager(manager: CLLocationManager,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            // ...
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}
