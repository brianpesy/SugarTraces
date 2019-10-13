//
//  InterfaceController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 05/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

struct Keys {
    static let savedReadings = "savedReadings"
    static let savedDates = "savedDates"
    static let savedAchievements = "savedAchievements"
    static let savedAchDates = "savedAchDates"
    static let savedConsecutiveDays = "savedConsecutiveDays"
    static let savedName = "savedName"
}


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    let defaults = UserDefaults.standard

    var loggedReadings: [Int] = []
    var loggedDates: [String] = []
    
    @IBOutlet weak var reading0Label: WKInterfaceLabel!
    @IBOutlet weak var date0Label: WKInterfaceLabel!
    @IBOutlet weak var feedbackLabel: WKInterfaceLabel!
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    

    @IBOutlet weak var lastReadingLabel: WKInterfaceLabel!
    var wcSession: WCSession!
    
    //essentially viewDidLoad of WatchKit
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        loadLoggedData()
        print("START OF THE APP") //works yay!
        print(loggedReadings)
        print(loggedDates)
        
        if loggedReadings.isEmpty {
            reading0Label.setText("")
            date0Label.setText("No entry yet!")
            date0Label.setTextColor(UIColor.white)
            feedbackLabel.setText("")
        } else {
            reading0Label.setText("\(String(loggedReadings[0])) mg/DL")
            if loggedReadings[0] < 70 { //below
                reading0Label.setTextColor(UIColor(red: 70/255, green: 117/255, blue: 255/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 70/255, green: 117/255, blue: 255/255, alpha: 1.0))
                feedbackLabel.setText("Sugar! Please!")
            } else if loggedReadings[0] > 150 { //above
                reading0Label.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setText("Lower is power!")
            } else { //normal
                reading0Label.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setText("You're amazing!")
            }
            date0Label.setText("On: \(loggedDates[0])")
        }
        
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
    
    func saveLoggedData(){
        defaults.set(loggedReadings, forKey: Keys.savedReadings)
        defaults.set(loggedDates, forKey: Keys.savedDates)
    }
    
    func loadLoggedData(){
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
//    @IBAction func btnTest() {
//        var testdict = ["test": "ss"]
//        wcSession.sendMessage(testdict, replyHandler: {reply in print("done")}, errorHandler: {error in print(error.localizedDescription)})
////        do {
////            print("went in")
////            try wcSession.updateApplicationContext(testdict)
////        } catch {
////            print("error")
////        }
//    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("AC")
//        print(applicationContext["readings"])
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
        
        if loggedReadings.isEmpty {
            reading0Label.setText("")
            date0Label.setText("No entry yet!")
            date0Label.setTextColor(UIColor.white)
            feedbackLabel.setText("")
        } else {
            reading0Label.setText("\(String(loggedReadings[0])) mg/DL")
            if loggedReadings[0] < 70 { //below
                reading0Label.setTextColor(UIColor(red: 70/255, green: 117/255, blue: 255/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 70/255, green: 117/255, blue: 255/255, alpha: 1.0))
                feedbackLabel.setText("Sugar! Please!")
            } else if loggedReadings[0] > 150 { //above
                reading0Label.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setText("Lower is power!")
            } else { //normal
                reading0Label.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setText("You're amazing!")
            }
            date0Label.setText("On: \(loggedDates[0])")
        }
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //I can do something after I send a message from the iPhone here
//        lastReadingLabel.setText(message["readings"] as? String)
//        var strArrReadings = message["readings"] as! [String]
        
        if message.keys.contains("readings"){
            loggedReadings = message["readings"] as! [Int]
        }
        
        if message.keys.contains("dates") {
            loggedDates = message["dates"] as! [String]
        }
        
//        if let loggedReadings = message["readings"] as! [Int]{
//            print("OUR READINGS ARE: ")
//            print(loggedReadings)
//        } else {
//            print("Error in getting readings")
//        }
//        if let loggedDates = message["dates"]{
//            print ("OUR DATES ARE: ")
//            print(loggedDates)
//        } else {
//            print("Error in getting dates")
//        }

        print(loggedReadings)
        print(loggedDates)
        print(loggedReadings[0])
        print(loggedDates[0])

//        var strArrDates = message["dates"] as! [String]

//        var strArrDates = [String]()
//        strArrDates = message["dates"] as! [String]
//        lastReadingLabel.setText(strArrReadings[0])
//        print(strArrDates)
//        print(strArrDates[0])
        
        //if i want to send something over, it's just
        //the same command for watch to iOS as well!
//        wcSession.sendMessage(message, replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
