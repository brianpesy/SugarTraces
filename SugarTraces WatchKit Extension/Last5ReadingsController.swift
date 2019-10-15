//
//  Last5ReadingsController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 15/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit

class Last5ReadingsController: WKInterfaceController, WCSessionDelegate {
    
    let defaults = UserDefaults.standard

    var loggedReadings: [Int] = []
    var loggedDates: [String] = []
    var wcSession: WCSession!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
        //get your data from the iPhone HERE (initial synchronization)
    }
    
    override func awake(withContext context: Any?) {
        loadLoggedData()
        //it already happens as the app already loads up... quite strange? Anyway, we work on the initial labels here
        print("LAST 5 READINGS CONTROLLER")
        print(loggedReadings)
        print(loggedDates)
    }
    
    //as we get information, we update the labels accordingly (both message and updatecontext)
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("message")
        if message.keys.contains("readings"){
            loggedReadings = message["readings"] as! [Int]
        }

        if message.keys.contains("dates") {
            loggedDates = message["dates"] as! [String]
        }

        saveLoggedData()

        print(loggedReadings)
        print(loggedDates)
        print(loggedReadings[0])
        print(loggedDates[0])
        print("-------")

    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("context")

        if applicationContext.keys.contains("readings"){
            loggedReadings = applicationContext["readings"] as! [Int]
        }

        if applicationContext.keys.contains("dates") {
            loggedDates = applicationContext["dates"] as! [String]
        }

        saveLoggedData()

        print(loggedReadings)
        print(loggedDates)
        print(loggedReadings[0])
        print(loggedDates[0])
        print("-------")
    }

    func loadLoggedData(){
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
    func saveLoggedData(){
        defaults.set(loggedReadings, forKey: Keys.savedReadings)
        defaults.set(loggedDates, forKey: Keys.savedDates)
    }
    
}
