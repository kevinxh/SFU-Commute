//
//  tripSchedulingViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit

class tripSchedulingViewController: UIViewController {
    

    @IBOutlet weak var seatsAvailable: UILabel!
    
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var riderView: UIView!
    
    @IBOutlet weak var DateTimePicker: UIDatePicker!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex{
            case 0:
                driverView?.isHidden = false
                riderView?.isHidden = true
            case 1:
                driverView?.isHidden = true
                riderView?.isHidden = false
            default:
                break;
        }
        
    }
    @IBAction func seatsAdd(_ sender: UIButton) {
        let addSeat = 1
        let maxSeats = 6
        let seatsCurrentlyAvailable = seatsAvailable.text!
        //seatsAvailable.text! = "Hello"
        
        if Int(seatsCurrentlyAvailable)! < maxSeats{
            let newSeats = Int(seatsCurrentlyAvailable)! + addSeat
            seatsAvailable!.text = String(newSeats)
            
        }
        else{
            seatsAvailable!.text = String(maxSeats)
        }
         
        
        
    }
    
    @IBAction func seatsSubtract(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        var dayComponent = DateComponents.init()
        dayComponent.day = 7
        let currentDate = Date.init()
        DateTimePicker.maximumDate = Calendar.current.date(byAdding: dayComponent, to: currentDate) //setting max date to be 7 days in advance
        DateTimePicker.minimumDate = currentDate //setting minimumDate so users can't choose a time before current time
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var dateAndTime: UIDatePicker!
    //Need date picker to only show current date + 7 days ahead. no past dates.

}
