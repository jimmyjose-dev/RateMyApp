//
//  ViewController.swift
//  RateMyApp
//
//  Created by Jimmy Jose on 08/09/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var rate = RateMyApp.sharedInstance
        
        rate.alertTitle = "asdasda"
        rate.alertMessage = "message"
        rate.alertOKTitle = "OK"
        rate.alertCancelTitle = "cancel"
        rate.alertRemindLaterTitle = "remind later"
        
        rate.showRatingAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

