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
import ClockKit

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
        
        let date = Date()
        let formatter = DateFormatter()
        //Date formatting
        formatter.timeZone = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        var nowDate = formatter.string(from:date)
        print(nowDate)
        
        //the same day means that it just returns consecutiveDays
//        print(consecutiveDaysCheck(prevDay: loggedDates[0], newDay: nowDate, consecutiveDays: 2))
        
        
        if loggedReadings.isEmpty || consecutiveDaysCheck(prevDay: loggedDates[0], newDay: nowDate, consecutiveDays: 2) != 2{ //no entries at all yet or no entry today yet (consecutiveDays is the same)
            reading0Label.setText("")
            date0Label.setText("No entry today yet!")
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
        
        let date = Date()
        let formatter = DateFormatter()
        //Date formatting
        formatter.timeZone = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        var nowDate = formatter.string(from:date)
        
        loadLoggedData()
        if loggedReadings.isEmpty || consecutiveDaysCheck(prevDay: loggedDates[0], newDay: nowDate, consecutiveDays: 2) != 2{ //no entries at all yet or no entry today yet (consecutiveDays is the same)
            reading0Label.setText("")
            date0Label.setText("No entry today yet!")
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
    
    func consecutiveDaysCheck(prevDay: String, newDay: String, consecutiveDays: Int) -> Int {
        //MM-DD-YYYY HH:MM:SS
        var dummy:String
        let prevDaySub = prevDay.prefix(10)
        let newDaySub = newDay.prefix(10)
        
        //0: month, 1: day, 2: year
        let prevDayArr = prevDaySub.components(separatedBy: "-").flatMap { Int($0) }
        let newDayArr = newDaySub.components(separatedBy: "-").flatMap { Int($0) }
        
        print(prevDayArr)
        
        //if it's the exact same day
        if (prevDayArr[0] == newDayArr[0] && prevDayArr[1] == newDayArr[1] && prevDayArr[2] == newDayArr[2]) {
            print("same day")
            return consecutiveDays
        }
        //31 dates: January, March, May, July, August, October, December (1, 3, 5, 7, 8, 10, 12)
        //30 dates: April, June, September, November (4, 6, 9, 11)
        //28 dates: February | 29 dates (every 4 years): February (2)
        
        //Consecutive days, same year
        if (newDayArr[1] == prevDayArr[1] + 1 && newDayArr[0] == prevDayArr[0] && newDayArr[2] == prevDayArr[2]) {
            print("consecutive day")
            return consecutiveDays + 1
        }
        
        //Changing months, consecutive days supposedly, same year (31 days)
        if (newDayArr[1] == 1 && prevDayArr[1] == 31){
            if ((prevDayArr[0] == 1 || prevDayArr[0] == 3 || prevDayArr[0] == 5 || prevDayArr[0] == 7 || prevDayArr[0] == 8 || prevDayArr[0] == 10 || prevDayArr[0] == 12) && (newDayArr[0] == 2 || newDayArr[0] == 4 || newDayArr[0] == 6 || newDayArr[0] == 8 || newDayArr[0] == 9 || newDayArr[0] == 11 || newDayArr[0] == 1) && (newDayArr[2] == prevDayArr[2])){
                //it's a 31 month
                print("31 month to another month")
                return consecutiveDays + 1
            }
        }
        
        //30 days, same year
        if (newDayArr[1] == 1 && prevDayArr[1] == 30){
            if ((prevDayArr[0] == 4 || prevDayArr[0] == 6 || prevDayArr[0] == 9 || prevDayArr[0] == 11) && (newDayArr[0] == 5 || newDayArr[0] == 7 || newDayArr[0] == 10 || newDayArr[0] == 12) && (newDayArr[2] == prevDayArr[2])){
                //it's a 30 month
                print("30 month to another month")

                return consecutiveDays + 1
            }
        }
        
        //Feb to March, same year
        if (prevDayArr[0] == 2){
            //leap year, 29 days
            if (prevDayArr[2] % 4 == 0){
                if (prevDayArr[1] == 29 && newDayArr[1] == 1 && newDayArr[0] == 3 && prevDayArr[2] == newDayArr[2]){
                    print("Feb to march, leap year")
                    return consecutiveDays + 1

                }
            } else {
                //no leap year, 28 days
                if (prevDayArr[1] == 28 && newDayArr[1] == 1 && newDayArr[0] == 3 && prevDayArr[2] == newDayArr[2]){
                    print("Feb to march, not leap year")
                    return consecutiveDays + 1
                }
            }
                        
            
        }
        
        //changing years, consecutive days supposedly
        if (newDayArr[2] == prevDayArr[2] + 1 && newDayArr[0] == 1 && prevDayArr[0] == 12 && newDayArr[1] == 1 && prevDayArr[1] == 31){
            print("HAPPY NEW YEAR")
            return consecutiveDays + 1
        }
        
        print(newDayArr)

        print("Not consecutive, reset")
        return 1
        
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
    
    private func reloadComplications() {
        if let complications: [CLKComplication] = CLKComplicationServer.sharedInstance().activeComplications {
            if complications.count > 0 {
                for complication in complications {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
                    NSLog("Reloading complication \(complication.description)...")
                }
                WKInterfaceDevice.current().play(WKHapticType.click) // haptic only for debugging
            }
        }
    }
    
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
        reloadComplications()
        
        print(loggedReadings)
        print(loggedDates)
        print(loggedReadings[0])
        print(loggedDates[0])
        print("-------")
        
        let date = Date()
        let formatter = DateFormatter()
        //Date formatting
        formatter.timeZone = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        var nowDate = formatter.string(from:date)
        
        if loggedReadings.isEmpty || consecutiveDaysCheck(prevDay: loggedDates[0], newDay: nowDate, consecutiveDays: 2) != 2 {
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
        print("AC")
        //        print(applicationContext["readings"])
        if message.keys.contains("readings"){
            loggedReadings = message["readings"] as! [Int]
        }
        
        if message.keys.contains("dates") {
            loggedDates = message["dates"] as! [String]
        }
        
        saveLoggedData()
        reloadComplications()
        
        print(loggedReadings)
        print(loggedDates)
        print(loggedReadings[0])
        print(loggedDates[0])
        print("-------")
        
        let date = Date()
        let formatter = DateFormatter()
        //Date formatting
        formatter.timeZone = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        var nowDate = formatter.string(from:date)
        
        if loggedReadings.isEmpty || consecutiveDaysCheck(prevDay: loggedDates[0], newDay: nowDate, consecutiveDays: 2) != 2 {
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
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
