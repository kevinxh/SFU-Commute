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
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var riderView: UIView!
    //@IBOutlet weak var DateTimePicker: UIDatePicker!
    @IBOutlet var startLocationLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    var role : role = .request
    var startLocation : location = location()
    var destination : location = location()
    
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
        initDateTimePicker()
        //var dayComponent = DateComponents.init()
        //dayComponent.day = 7
        //let currentDate = Date.init()
        //DateTimePicker.maximumDate = Calendar.current.date(byAdding: dayComponent, to: currentDate) //setting max date to be 7 days in advance
        //DateTimePicker.minimumDate = currentDate //setting minimumDate so users can't choose a time before current time
    }
    
    func initDateTimePicker() {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 7)
        var current = Date()
        let picker = DateTimePicker.show(selected: current, minimumDate: min, maximumDate: max)
        picker.highlightColor = Colors.SFUBlueHighlight
        picker.doneButtonTitle = "Set"
        picker.todayButtonTitle = "Now"
        picker.completionHandler = { date in
            current = date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd/MM/YYYY"
            print(formatter.string(from: date))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
