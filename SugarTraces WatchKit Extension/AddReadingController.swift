//
//  AddReadingController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 15/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit

class AddReadingController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var readingTextField: WKInterfaceTextField!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    @IBAction func textField(_ value: NSString?) {
        //whatever value is typed here will be saved to the loggedReading and date, sent over to the main app as well.
        print(value!)
    }
    
    
}
