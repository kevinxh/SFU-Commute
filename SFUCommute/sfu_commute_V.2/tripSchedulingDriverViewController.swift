//
//  tripSchedulingViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit
import EasyTipView
import SwiftyButton

class tripSchedulingViewController: UIViewController {
    
    @IBOutlet var locationDetailView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var setTimeButton: FlatButton!
    @IBOutlet weak var dateAndTime: UIDatePicker!
    @IBOutlet weak var seatsAvailable: UILabel!
    @IBOutlet weak var seatsOfferOrRequest: UILabel!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var riderView: UIView!
    //@IBOutlet weak var DateTimePicker: UIDatePicker!
    @IBOutlet var startLocationLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
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
    
    func setTimeText(_ time : Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/YYYY"
        timeLabel.text = formatter.string(from: time)
    }
    
    @IBAction func setTimeBtnTapped(_ sender: AnyObject) {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 7)
        let current = Date()
        let picker = DateTimePicker.show(selected: current, minimumDate: min, maximumDate: max)
        picker.highlightColor = Colors.SFUBlueHighlight
        picker.doneButtonTitle = "Set"
        picker.todayButtonTitle = "Now"
        picker.completionHandler = { date in
            self.tips.dismiss()
            if (date.compare(Date()).rawValue == -1){
                self.tips = EasyTipView(text:"Please select a time in future.")
                self.tips.show(forView: picker.contentView)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    // animate to show contentView
                    picker.contentView.frame = CGRect(x: 0,
                                                    y: picker.frame.height,
                                                    width: picker.frame.width,
                                                    height: picker.contentHeight)
                })
            }
            self.setTimeText(date)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
