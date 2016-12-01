//
//  tripSchedulingViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import Foundation
import UIKit
import EasyTipView
import Alamofire
import SwiftyButton
import SwiftyJSON

class tripSchedulingViewController: UIViewController {
    
    @IBOutlet var locationDetailView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var dateAndTime: UIDatePicker!
    @IBOutlet weak var seatsAvailable: UILabel!
    @IBOutlet weak var seatsOfferOrRequest: UILabel!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var riderView: UIView!
    @IBOutlet var startLocationLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    var confirmButton : FlatButton = FlatButton()
    
    var role : role = .request
    var startLocation : location = location()
    var destination : location = location()
    var time : Date = Date()
    var tips : EasyTipView = EasyTipView(text:"Unknown error occurs.")
    
    override func viewDidAppear(_ animated: Bool) {
        switch role{
        case .offer:
            seatsOfferOrRequest.text! = "Seats Offering"
            priceLabel.text = "$1 - $2"
        case .request:
            seatsOfferOrRequest.text! = "Seats Requesting"
            
            // need to work on this later.
            priceLabel.text = "$" + startLocation.price.description
        }
        startLocationLabel.text = startLocation.name
        destinationLabel.text = destination.name
    }
    
    @IBAction func seatsAdd(_ sender: UIButton) {
        let addSeat = 1
        let maxSeats = 6
        let seatsCurrentlyAvailable = seatsAvailable.text!
        if Int(seatsCurrentlyAvailable)! < maxSeats{
            let newSeats = Int(seatsCurrentlyAvailable)! + addSeat
            seatsAvailable!.text = String(newSeats)
        }
        else{
            seatsAvailable!.text = String(maxSeats)
        }
    }
    
    @IBAction func seatsSubtract(_ sender: UIButton) {
        let subSeat = 1
        let minSeats = 1
        let seatsCurrentlyAvailable = seatsAvailable.text!
        if Int(seatsCurrentlyAvailable)! > minSeats{
            let newSeats = Int(seatsCurrentlyAvailable)! - subSeat
            seatsAvailable!.text = String(newSeats)
        }
        else{
            seatsAvailable!.text = String(minSeats)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeText(Date())
        initButton()
        let tap = UITapGestureRecognizer(target: self, action: #selector(timeLabelTapped))
        timeLabel.isUserInteractionEnabled = true
        timeLabel.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let shadowPath = UIBezierPath(rect: locationDetailView.bounds)
        locationDetailView.layer.masksToBounds = false
        locationDetailView.layer.shadowColor = UIColor.black.cgColor
        locationDetailView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        locationDetailView.layer.shadowOpacity = 0.3
        locationDetailView.layer.shadowPath = shadowPath.cgPath
    }
    
    func initButton() {
        confirmButton.SFURedDefault("Confirm")
        confirmButton.addTarget(self, action: #selector(self.verifyTapped(_:)), for: .touchUpInside)
        self.view.addSubview(confirmButton)
        confirmButton.wideBottomConstraints(superview: self.view)
    }
    
    func setTimeText(_ time : Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        timeLabel.text = formatter.string(from: time)
    }
    
    func timeLabelTapped(_ sender: AnyObject) {
        let min = Date().addingTimeInterval(60 * 15) //shows 15 minutes from now so you can't schedule right away
        let max = Date().addingTimeInterval(60 * 60 * 24 * 7) //max 7 days from now
        //let current = Date()
        let picker = DateTimePicker.show(selected: min, minimumDate: min, maximumDate: max)
        picker.highlightColor = Colors.SFUBlueHighlight
        picker.doneButtonTitle = "Set"
        picker.todayButtonTitle = "Now"
        picker.completionHandler = { date in
            self.tips.dismiss()
            if (date.compare(Date()).rawValue == -1){
                self.tips = EasyTipView(text:"Please select a time in the future.")
                self.tips.show(forView: picker.contentView)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    // animate to show contentView
                    picker.contentView.frame = CGRect(x: 0,
                                                    y: picker.frame.height,
                                                    width: picker.frame.width,
                                                    height: picker.contentHeight)
                })
                picker.removeFromSuperview()
            }
            self.time = date
            self.setTimeText(date)
            
        }
    }
    
    func verifyTapped(_ sender: FlatButton){
        //do some checks
        sendRequest()
        
        printDateAndTime()
       
    }
    
    func printDateAndTime(){
        let dateFormatter = DateFormatter()
        //let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSSZZZZZ" //following ISO 8601
        //timeFormatter.dateFormat = "HH:mm"
        
        let rideDate = dateFormatter.string(from: time)
        //let rideTime = timeFormatter.string(from: time)
        
        /*
        var scheduler:String = ""
        if role == .request{
            scheduler = "Rider"
        }
        else if role == .offer{
            scheduler = "Driver"
        }
 
        print(scheduler)
         */
        print(startLocation.lat)
        print(startLocation.lon)
        print(destination.lat)
        print(destination.lon)
        print(seatsAvailable.text!)
        print(rideDate)
    }
    
    func sendRequest(){
        
        //let startLocation = startLocationLabel.text!
        //let destinationLocation = destinationLabel.text!
        //let seatsOfferedOrRequested = seatsAvailable.text!
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSSZZZZZ" //following ISO 8601
        let rideDate = dateFormatter.string(from: time)
 
        var scheduler = String()
        if role == .request{
            scheduler = "Rider"
        }
        else if role == .offer{
            scheduler = "Driver"
        }
     
        
        let parameters : Parameters = [
                            "schedulerType": scheduler,
                            "startLocationLat": startLocation.lat,
                            "startLocationLon": startLocation.lon,
                            "destinationLat": destination.lat,
                            "destinationLon": destination.lon,
                            "seats": seatsAvailable.text!,
                            "date": rideDate,
                            
                            //optional fields
                            "startLocationID": startLocation.id,
                            "startLocationName": startLocation.name,
                            "destinationID": destination.id,
                            "destinationName": destination.name
            
                        ]
        
        AuthorizedRequest.request(API.ride(parameters: parameters)).responseJSON{ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                if (json["success"] == true) {
                    print("success")
                } else {
                    
                    // to do: error handling!
                    self.confirmButton.isEnabled = true
                    self.tips = EasyTipView(text:"Error occurs, please try again later")
                    self.tips.show(forView: self.confirmButton)
                }
                
            case .failure(let error):
                print(error)
                self.confirmButton.isEnabled = true
                self.tips = EasyTipView(text:error.localizedDescription)
                self.tips.show(forView: self.confirmButton)
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
