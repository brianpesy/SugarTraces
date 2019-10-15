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
    
//    @IBOutlet weak var reading0Label: WKInterfaceLabel!
//    @IBOutlet weak var date0Label: WKInterfaceLabel!
//
//    @IBOutlet weak var reading1Label: WKInterfaceLabel!
//    @IBOutlet weak var date1Label: WKInterfaceLabel!
//
//    @IBOutlet weak var reading2Label: WKInterfaceLabel!
//    @IBOutlet weak var date2Label: WKInterfaceLabel!
//
//    @IBOutlet weak var reading3Label: WKInterfaceLabel!
//    @IBOutlet weak var date3Label: WKInterfaceLabel!
//
//    @IBOutlet weak var reading4Label: WKInterfaceLabel!
//    @IBOutlet weak var date4Label: WKInterfaceLabel!
        
    @IBOutlet weak var r0Label: WKInterfaceLabel!
    @IBOutlet weak var d0Label: WKInterfaceLabel!
    
    @IBOutlet weak var r1Label: WKInterfaceLabel!
    @IBOutlet weak var d1Label: WKInterfaceLabel!
    
    @IBOutlet weak var r2Label: WKInterfaceLabel!
    @IBOutlet weak var d2Label: WKInterfaceLabel!
    
    @IBOutlet weak var r3Label: WKInterfaceLabel!
    @IBOutlet weak var d3Label: WKInterfaceLabel!
    
    @IBOutlet weak var r4Label: WKInterfaceLabel!
    @IBOutlet weak var d4Label: WKInterfaceLabel!
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    override func willActivate() { //viewdidappear of Watch
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
        //get your data from the iPhone HERE (initial synchronization)
        loadLoggedData()
        if loggedReadings.isEmpty {
            r0Label.setText("")
            d0Label.setText("")
            r1Label.setText("")
            d1Label.setText("")
            r2Label.setText("")
            d2Label.setText("")
            r3Label.setText("No entries yet!")
            d3Label.setText("")
            r4Label.setText("")
            d4Label.setText("")
        } else {
            print("hi \(loggedReadings.count)")
            if loggedReadings.count >= 5 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("\(loggedReadings[4]) mg/DL")
                d4Label.setText("\(loggedDates[4].prefix(10))")
                r4Label.setTextColor(colorPicker(entry: loggedReadings[4]))
            } else if loggedReadings.count == 4 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                 
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 3 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 2 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 1 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("")
                d1Label.setText("")
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        loadLoggedData()
        //it already happens as the app already loads up... quite strange? Anyway, we work on the initial labels here
        print("LAST 5 READINGS CONTROLLER")
        if loggedReadings.isEmpty {
            r0Label.setText("")
            d0Label.setText("")
            r1Label.setText("")
            d1Label.setText("")
            r2Label.setText("")
            d2Label.setText("")
            r3Label.setText("No entries yet!")
            d3Label.setText("")
            r4Label.setText("")
            d4Label.setText("")
        } else {
            print("hi \(loggedReadings.count)")
            if loggedReadings.count >= 5 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("\(loggedReadings[4]) mg/DL")
                d4Label.setText("\(loggedDates[4].prefix(10))")
                r4Label.setTextColor(colorPicker(entry: loggedReadings[4]))
            } else if loggedReadings.count == 4 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                 
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 3 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 2 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 1 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("")
                d1Label.setText("")
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
            }
        }

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
        
        if loggedReadings.isEmpty {
            r0Label.setText("")
            d0Label.setText("")
            r1Label.setText("")
            d1Label.setText("")
            r2Label.setText("")
            d2Label.setText("")
            r3Label.setText("No entries yet!")
            d3Label.setText("")
            r4Label.setText("")
            d4Label.setText("")
        } else {
            print("hi \(loggedReadings.count)")
            if loggedReadings.count >= 5 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("\(loggedReadings[4]) mg/DL")
                d4Label.setText("\(loggedDates[4].prefix(10))")
                r4Label.setTextColor(colorPicker(entry: loggedReadings[4]))
            } else if loggedReadings.count == 4 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                 
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 3 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 2 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 1 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("")
                d1Label.setText("")
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
            }
        }

    }
    
    func colorPicker(entry: Int) -> UIColor{
        print(entry)
        
        if entry < 70 {
            return UIColor(red: 70/255, green: 117/255, blue: 255/255, alpha: 1.0)
        } else if entry > 150 {
            return UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0)
        } else {
            return UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0)
        }
        /*
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
         
         */
//        return UIColor(red: 70/255, green: 117/255, blue: 255/255, alpha: 1.0)
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
        
        if loggedReadings.isEmpty {
            r0Label.setText("")
            d0Label.setText("")
            r1Label.setText("")
            d1Label.setText("")
            r2Label.setText("")
            d2Label.setText("")
            r3Label.setText("No entries yet!")
            d3Label.setText("")
            r4Label.setText("")
            d4Label.setText("")
        } else {
            print("hi \(loggedReadings.count)")
            if loggedReadings.count >= 5 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("\(loggedReadings[4]) mg/DL")
                d4Label.setText("\(loggedDates[4].prefix(10))")
                r4Label.setTextColor(colorPicker(entry: loggedReadings[4]))
            } else if loggedReadings.count == 4 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                 
                r3Label.setText("\(loggedReadings[3]) mg/DL")
                d3Label.setText("\(loggedDates[3].prefix(10))")
                r3Label.setTextColor(colorPicker(entry: loggedReadings[3]))
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 3 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))

                r2Label.setText("\(loggedReadings[2]) mg/DL")
                d2Label.setText("\(loggedDates[2].prefix(10))")
                r2Label.setTextColor(colorPicker(entry: loggedReadings[2]))
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 2 {
                
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                 
                r1Label.setText("\(loggedReadings[1]) mg/DL")
                d1Label.setText("\(loggedDates[1].prefix(10))")
                r1Label.setTextColor(colorPicker(entry: loggedReadings[1]))
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
                
            } else if loggedReadings.count == 1 {
                r0Label.setText("\(loggedReadings[0]) mg/DL")
                d0Label.setText("\(loggedDates[0].prefix(10))")
                r0Label.setTextColor(colorPicker(entry: loggedReadings[0]))
                
                r1Label.setText("")
                d1Label.setText("")
                
                r2Label.setText("")
                d2Label.setText("")
                
                r3Label.setText("")
                d3Label.setText("")
                
                r4Label.setText("")
                d4Label.setText("")
            }
        }
        
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
