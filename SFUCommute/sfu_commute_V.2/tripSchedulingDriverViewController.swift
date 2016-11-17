//
//  tripSchedulingViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit

class tripSchedulingViewController: UIViewController {
    
    @IBOutlet weak var dateAndTime: UIDatePicker!
    @IBOutlet weak var seatsAvailable: UILabel!
    @IBOutlet weak var seatsOfferOrRequest: UILabel!
    @IBOutlet weak var tipDriver: UILabel!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var riderView: UIView!
    @IBOutlet weak var DateTimePicker: UIDatePicker!
    
    var role : role = .request
    var s = location()
    var d = location()
    
    override func viewDidAppear(_ animated: Bool) {
        switch role{
        case .offer:
            seatsOfferOrRequest.text! = "Seats Offering"
            tipDriver.text! = ""
        case .request:
            seatsOfferOrRequest.text! = "Seats Requesting"
            tipDriver.text! = "You are welcome to tip the driver"
        }
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
        var dayComponent = DateComponents.init()
        dayComponent.day = 7
        let currentDate = Date.init()
        DateTimePicker.maximumDate = Calendar.current.date(byAdding: dayComponent, to: currentDate) //setting max date to be 7 days in advance
        DateTimePicker.minimumDate = currentDate //setting minimumDate so users can't choose a time before current time
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
