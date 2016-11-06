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
import SideMenu
import FontAwesome_swift
import CoreLocation

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
    
    var emailStartPoint: textField! = textField()
    
    func initTextFields() {
        if #available(iOS 10.0, *) {
            emailStartPoint.textContentType = .fullStreetAddress
        } else {
            // Fallback on earlier versions
        }
        emailStartPoint.autocorrectionType = .no
        emailStartPoint.autocapitalizationType = .none
        print("This is the manager::::::::::::::::::::::::::::::::::::::")
        print(manager)
        emailStartPoint.placeholder = ""
        //emailStartPoint.addTarget(self, action: #selector(self.emailChanged(_:)), for: .editingChanged)
        view.addSubview(emailStartPoint)
        emailStartPoint.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(30)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalToSuperview()
        }
    }
    
    let manager = CLLocationManager()
    var firstPoint = true
    var lastCoordinate: CLLocation?
    var lastSpeed = SpeedDisplay(speedMetersPerSecond: 0)
    var currentUnits = speedUnit.metersPerSecond
    
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet weak var header2View: UIView!
    @IBOutlet weak var currentUnitsLabel: UILabel!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    @IBAction func hiDidGetPressed(_ sender: UIButton) {
        print("hi \(mapView)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSideMenu()
        initNavBar()
        initTextFields()
        //  self.currentUnitsLabel.
        self.currentUnitsLabel.text = lastSpeed.labelForUnit(units: self.currentUnits)
        _ = UITapGestureRecognizer(target: self, action: Selector(("tapFunction:")))
        //     tripDetails.addGestureRecognizer(tap)
        self.blurTitleViews()
        self.setupMap()
        self.setupLocationManager()
        self.view.backgroundColor = Colors.darkBlueGrey
    }
    
    func initSideMenu(){
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "sideMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: mapView)
        SideMenuManager.menuFadeStatusBar = false
    }
    
    func initNavBar() {
        let leftBarIconButton = UIBarButtonItem()
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 24)] as [String: Any]
        leftBarIconButton.setTitleTextAttributes(attributes, for: .normal)
        leftBarIconButton.title = String.fontAwesomeIcon(code: "fa-bars")
        leftBarIconButton.tintColor = UIColor.white
        leftBarIconButton.action = #selector(self.leftBarIconButtonTapped)
        navBarItem.leftBarButtonItem = leftBarIconButton
    }
    
    func leftBarIconButtonTapped(_ sender: Any?){
        performSegue(withIdentifier: "showSideMenu", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
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
        mapView.styleURL = MGLStyle.darkStyleURL()
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
        //print(manager.locality ? manager.locality : "")
        //print(manager.postalCode ? manager.postalCode : "")
        //print(placemark.administrativeArea ? placemark.administrativeArea : "")
        //print(manager.country ? manager.country : "")
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
