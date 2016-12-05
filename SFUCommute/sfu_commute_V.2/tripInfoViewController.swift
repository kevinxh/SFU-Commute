
//
//  tripInfoViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

/*
 
 Jonathan
 
 */
 
 
import UIKit
import SwiftyButton

class tripInfoViewController: UIViewController {
    
    @IBOutlet var from: UILabel!
    @IBOutlet var to: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var seats: UILabel!
    
    var fromText:String = ""
    var toText:String = ""
    var timeText:String = ""
    var seatsText:String = ""
    
    var joinTripButton : FlatButton = FlatButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        initButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        from.text = fromText
        to.text = toText
        time.text = timeText
        seats.text = seatsText
    }
    
    func initButton() {
        joinTripButton.SFURedDefault("Join this trip")
        // joinTripButton.addTarget(self, action: #selector(self.joinBtnTapped(_:)), for: .touchUpInside)
        self.view.addSubview(joinTripButton)
        joinTripButton.wideBottomConstraints(superview: self.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
