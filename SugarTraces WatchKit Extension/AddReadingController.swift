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
import AVFoundation

extension NSString {
    var isInt: Bool {
        return Int(self as String) != nil
    }
}

class AddReadingController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var readingTextField: WKInterfaceTextField!
    
    var audioPlayer: AVAudioPlayer!
    
    let defaults = UserDefaults.standard

    var loggedReadings: [Int] = []
    var loggedDates: [String] = []
    
    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    var loggedConsecutiveDays = 0
    
    var wcSession: WCSession!
    
    var transferToPhone: [String: [Any]] = [:]
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    override func awake(withContext context: Any?) {
        loadAchievements()
        loadConsecutiveDays()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
        
        saveAchievements()
        print(loggedAchievements)
        print(loggedAchDates)
        print("awake: \(loggedConsecutiveDays)")

        loadConsecutiveDays()
    }
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
    }
    
    func loadLoggedData(){
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
    func loadAchievements(){
        var savedAchievements = defaults.array(forKey: Keys.savedAchievements) as? [Bool] ?? [Bool]()
        loggedAchievements = savedAchievements
        
        var savedAchDates = defaults.array(forKey: Keys.savedAchDates) as? [String] ?? [String]()
        loggedAchDates = savedAchDates
    }
    
    func loadConsecutiveDays(){
        var savedConsecutiveDays = defaults.integer(forKey: Keys.savedConsecutiveDays)
        loggedConsecutiveDays = savedConsecutiveDays
    }
    
    func saveLoggedData(){
        defaults.set(loggedReadings, forKey: Keys.savedReadings)
        defaults.set(loggedDates, forKey: Keys.savedDates)
    }
    
    func saveAchievements(){
        defaults.set(loggedAchievements, forKey: Keys.savedAchievements)
        defaults.set(loggedAchDates, forKey: Keys.savedAchDates)
    }
    
    func saveConsecutiveDays(){
        defaults.set(loggedConsecutiveDays, forKey: Keys.savedConsecutiveDays)
    }
    
    func achievementCheck(){
        //ADD GLUCOSE
        //entered your first reading 0
        if (!(loggedReadings.indices.contains(1)) && loggedAchievements[0] != true){
            print("ACHIEVEMENT 1 GET")
            
            //Achievement get
            loggedAchievements[0] = true
            
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[0] = formatter.string(from:date)
            
            //Alert that you got an achievement
            // create the alert
            let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                print("Ok")
            }
            presentAlert(withTitle: "Achievement!", message: "You entered your first reading!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])

            saveAchievements()
        }
        
        //entered 4 consecutive normal readings after an above normal reading 1
        if (loggedReadings.indices.contains(4) && loggedAchievements[1] != true){
            if (loggedReadings[4] > 150){
                for i in 0..<4{

                    if (loggedReadings[i] < 70 || loggedReadings[i] > 150){
                        break
                    }
                    if (i == 3){
                        print("ACHIEVEMENT")
                        //Achievement get
                        loggedAchievements[1] = true
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        //Date formatting
                        formatter.timeZone = .current
                        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                        
                        //Date when achievement was gotten
                        loggedAchDates[1] = formatter.string(from:date)
                        
                        // create the alert
                        let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                            print("Ok")
                        }
                        presentAlert(withTitle: "Achievement!", message: "You entered 4 consecutive readings after an above normal reading!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                        
                        saveAchievements()

                    }
                }
            }
        }
        
        //entered 5 consecutive normal readings 2
        if (loggedReadings.indices.contains(4) && loggedAchievements[2] != true){
            for i in 0..<5 {
                if (loggedReadings[i] < 70 || loggedReadings[i] > 150){
                    break
                }
                if (i == 4){
                    print("ACHIEVEMENT")
                    
                    //Achievement get
                    loggedAchievements[2] = true
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    //Date formatting
                    formatter.timeZone = .current
                    formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                    
                    //Date when achievement was gotten
                    loggedAchDates[2] = formatter.string(from:date)
                    
                    // create the alert
                    let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                        print("Ok")
                    }
                    presentAlert(withTitle: "Achievement!", message: "You entered 5 consecutive normal readings!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                    
                    saveAchievements()
                }
            }
        }
        
        
        //entered 4 consecutive normal readings after a below normal reading 3
        if (loggedReadings.indices.contains(4) && loggedAchievements[3] != true){
            if (loggedReadings[4] < 70){
                for i in 0..<4{

                    if (loggedReadings[i] < 70 || loggedReadings[i] > 150){
                        break
                    }
                    if (i == 3){
                        print("ACHIEVEMENT")
                        //Achievement get
                        loggedAchievements[3] = true
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        //Date formatting
                        formatter.timeZone = .current
                        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                        
                        //Date when achievement was gotten
                        loggedAchDates[3] = formatter.string(from:date)
                        
                        // create the alert
                        let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                            print("Ok")
                        }
                        presentAlert(withTitle: "Achievement!", message: "You entered 4 consecutive normal readings after a below normal reading!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                        
                        saveAchievements()

                    }
                }
            }
        }
        
        //entered 10 consecutive normal readings 4
        if (loggedReadings.indices.contains(9) && loggedAchievements[4] != true){
            for i in 0..<10 {
                if (loggedReadings[i] < 70 || loggedReadings[i] > 150){
                    break
                }
                if (i == 9){
                    print("ACHIEVEMENT")
                    
                    //Achievement get
                    loggedAchievements[4] = true
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    //Date formatting
                    formatter.timeZone = .current
                    formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                    
                    //Date when achievement was gotten
                    loggedAchDates[4] = formatter.string(from:date)
                    
                    // create the alert
                    let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                        print("Ok")
                    }
                    presentAlert(withTitle: "Achievement!", message: "You entered 10 consecutive readings!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                    
                    saveAchievements()
                }
            }
        }
        
        //had a normal blood glucose streak for 3 days 5
        //check everything in the array loggedDates, parse info
            //if the same month-day-year
        //DATE FORMAT: MM-DD-YYYY HH:MM:SS
        
        if (loggedConsecutiveDays == 3 && loggedAchievements[5] != true){
            //there needs to be at least 3 readings for this
            
            //Achievement get
            loggedAchievements[5] = true
            
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[5] = formatter.string(from:date)
            
            // create the alert
            let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                print("Ok")
            }
            presentAlert(withTitle: "Achievement!", message: "You entered normal readings for 3 days in a row!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
            
            saveAchievements()
            
        }
        
        //entered a normal reading after an above reading 6
        if (loggedReadings.indices.contains(1) && loggedAchievements[6] != true){
            if (loggedReadings[1] > 150 && loggedReadings[0] > 69 && loggedReadings[0] < 151){
                print("ACHIEVEMENT")
                //Achievement get
                loggedAchievements[6] = true
                
                let date = Date()
                let formatter = DateFormatter()
                //Date formatting
                formatter.timeZone = .current
                formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                
                //Date when achievement was gotten
                loggedAchDates[6] = formatter.string(from:date)
                
                // create the alert
                let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                    print("Ok")
                }
                presentAlert(withTitle: "Achievement!", message: "You entered a normal reading after an above reading!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                
                saveAchievements()
            }
        }
        
        //entered a normal reading after a below reading 7
        if (loggedReadings.indices.contains(1) && loggedAchievements[7] != true){
            if (loggedReadings[1] < 70 && loggedReadings[0] > 69 && loggedReadings[0] < 151){
                print("ACHIEVEMENT")
                //Achievement get
                loggedAchievements[7] = true
                
                let date = Date()
                let formatter = DateFormatter()
                //Date formatting
                formatter.timeZone = .current
                formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                
                //Date when achievement was gotten
                loggedAchDates[7] = formatter.string(from:date)
                
                // create the alert
                let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                    print("Ok")
                }
                presentAlert(withTitle: "Achievement!", message: "You entered a normal reading after a below reading!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                
                saveAchievements()
            }
        }
        
        //entered 15 consecutive normal readings 8
        if (loggedReadings.indices.contains(14) && loggedAchievements[8] != true){
            for i in 0..<15 {
                if (loggedReadings[i] < 70 || loggedReadings[i] > 150){
                    break
                }
                if (i == 14){
                    print("ACHIEVEMENT")
                    
                    //Achievement get
                    loggedAchievements[8] = true
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    //Date formatting
                    formatter.timeZone = .current
                    formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                    
                    //Date when achievement was gotten
                    loggedAchDates[8] = formatter.string(from:date)
                    
                    // create the alert
                    let action = WKAlertAction(title: "Got it!", style: WKAlertActionStyle.default) {
                        print("Ok")
                    }
                    presentAlert(withTitle: "Achievement!", message: "You entered 15 consecutive normal readings!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                    
                    saveAchievements()
                }
            }
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
    
    
    @IBAction func textField(_ value: NSString?) {
        //whatever value is typed here will be saved to the loggedReading and date, sent over to the main app as well.
        //sound effect after inputting
        if value != nil && value != ""{
            if value!.isInt {
                //load whatever is in
                loadLoggedData()
                
                print(value!)
                var num = Int(value! as String)!
                //sound effect
                let dingPath = Bundle.main.path(forResource: "adding.wav", ofType: nil)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingPath!))
                } catch {
                    print(error)
                }
                audioPlayer.play()
                
                if num > 69 && num < 151 {
                    if loggedConsecutiveDays == 0 {
                        loggedConsecutiveDays = 1
                    } else {
                        loggedConsecutiveDays = consecutiveDaysCheck(prevDay: loggedDates[1], newDay: loggedDates[0], consecutiveDays: loggedConsecutiveDays)
                    }
                } else {
                    loggedConsecutiveDays = 0
                }
                print("consecutive days: \(loggedConsecutiveDays)")
                                
                //Put data in array
                let date = Date()
                let formatter = DateFormatter()
                //Date formatting
                formatter.timeZone = .current
                formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                
                loggedReadings.insert(num, at: 0)
                loggedDates.insert(formatter.string(from:date), at:0)
                
                print("inside watch")
                print(loggedReadings)
                print(loggedDates)
                
                saveLoggedData()
                saveConsecutiveDays()
                
                achievementCheck()
                reloadComplications()
                
                //send over data to the iPhone app
                
                if WCSession.isSupported() {
                    self.wcSession = WCSession.default
                    self.wcSession.delegate = self
                    self.wcSession.activate()
                }
                
                transferToPhone = ["readings": loggedReadings, "dates": loggedDates, "ach": loggedAchievements, "achDates": loggedAchDates]
                var transferConsDays = ["consecutiveDays": loggedConsecutiveDays]
                //when I send a message over with the Text Field, I can send it to the WC Session.
                
//                wcSession.sendMessage(transferToPhone, replyHandler: nil, errorHandler: error in print(error.localizedDescription))
//                    replyHandler()
//                wcSession.sendMessage(transferToPhone, replyHandler: {(_ replyMessage: [String: Any]) -> Void in
//
//                    print("ReplyHandler called = \(replyMessage)")
//                },
//                errorHandler: {(_ error: Error) -> Void in
//
//                    print("Error = \(error.localizedDescription)")
//                })
                if wcSession.isReachable {
                    wcSession.sendMessage(transferToPhone, replyHandler: {reply in print("done")}, errorHandler: {error in
                        
                        do {
                            try self.wcSession.updateApplicationContext(self.transferToPhone)

                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    
                    print("sent data over to phone")
                    
                    wcSession.sendMessage(transferConsDays, replyHandler: {reply in print("done")}, errorHandler: {error in
                        
                        do {
                            try self.wcSession.updateApplicationContext(transferConsDays)

                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
                print("bam")
            }
        }
    }
    
    
}
