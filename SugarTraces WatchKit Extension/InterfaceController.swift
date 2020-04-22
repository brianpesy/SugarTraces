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

//Below 70
var belowFeedback = ["I think you should sit down, reflect on your blood sugar and munch on a banana.",
"You need sugar too you know! Don’t reduce your sugar intake by that much!",
"There’s a secret I want to tell you. Go get yourself some sugar.",
"I told you that too much sugar is not healthy. Did you think too less is better? Work on getting that to a normal level.",
"If you want this relationship to work, you have to munch on some bananas to get your sugar to normal.",
"Next time you go for a drink, be sure to eat first. Your body needs some glucose to be produced!",
"Fruits are a great way to get your blood sugar back up! (They are also a really tasty way too)",
"Be sure to eat enough before you exercise. Your body needs fuel too, you know? ",
"Low blood sugar isn’t any better than a high blood sugar. Bump that glucose up!",
"Maybe you took the tips a bit too much to heart. Loosen up and drink a small glass of orange juice!",
"You’re running low on sugar. You are doing it wrong!",
"Low blood sugar levels kill, you know!",
"You think skipping meals is good for you? Not always! See what you did?"]

//Range of 70-150
var normalFeedback = ["Good job! Now we just have to keep this up until FOREVER!",
"That’s what I’m talking about! I heard that keeping a normal blood sugar will earn you something nice.",
"Looks like someone’s got a normal blood sugar! Yes, that’s you! Good job!",
"I have good news for you: you`re NORMAL! Both blood sugar and everything else.",
"I would like to use this opportunity to give you a digital pat for having a normal blood sugar level. *pats*",
"Hey, you! Yes, you! I like that blood sugar of yours. *wink*",
"A trip to the gym a day keeps the blood sugar levels stay!",
"Don’t just keep drinking water. Keep doing it consistently to maintain your blood sugar!",
"Systems? Check. Blood sugar? Check. We’re all set and ready!",
"Seeing normal here makes me do the dance of joy.",
"It worked! Whatever you did, it made your blood sugar level normalize! Keep it up!",
"That 30-minute brisk walking did wonders! Good job!",
"Don’t you feel amazing right now? Share the joy!",
"Congratulations! *high five* ",
"You just made everyone happy that you are not sick!",
"Your mom would be proud of you! Do it again."]

//Range above 150
var aboveFeedback = ["Too much carbs actually turn into glucose. Sounda familiar? Control what you eat",
"Stress increases your blood sugar levels. Relax for a bit!",
"A reminder from your friendly neighborhood app that eating too much is not good for you.",
"You can't go back to old habits. You're so close! I believe in you!",
"I'm pretty sure I saw that soda in your pantry. That won't help you out.",
"Something doesn't seem right. I can't put my finger on it, but I'm sure you know what's wrong.",
"Don't get glued to glucose. Get it? You really need to lower this!",
"You may be trying really hard right now, but it's not good enough! I'll help you out!",
"We’re looking at long term health here. Living a long and healthy life should be your goal!",
"Drink some water and flush that glucose out of your system. Fun fact: It has no sugar!",
"I think diets are pretty neat. I think you could use one?",
"That extra serving does not look appetizing now, huh? Now go for a 30-minute jog!",
"“Ready, set, go!“ is for marathons, not for buffets! Stop it!",
"“Unlimited” is only good for your phone’s internet, not for your belly! ",
"GLUTTON!!!! You are now one step closer to a hospital vacation! ",
"Buy one, take one is meant to be shared! You over-eater you!",
"Fruit juices are not substitutes to the actual fruits! Stop juicing!",
"Do you have a death wish? No? Then stop and lower your blood sugar level!"]


//home page of the watch application

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    let defaults = UserDefaults.standard

    var loggedReadings: [Int] = []
    var loggedDates: [String] = []
    
    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    var loggedConsecutiveDays = 0

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
        loadAchievements()
        loadConsecutiveDays()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
        
        saveAchievements()
        
        
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
                belowFeedback.shuffle()
                feedbackLabel.setText(belowFeedback[0])
            } else if loggedReadings[0] > 150 { //above
                reading0Label.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setText("Lower is power!")
                aboveFeedback.shuffle()
                feedbackLabel.setText(aboveFeedback[0])
            } else { //normal
                reading0Label.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setText("You're amazing!")
                normalFeedback.shuffle()
                feedbackLabel.setText(normalFeedback[0])
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
//                feedbackLabel.setText("Sugar! Please!")
                belowFeedback.shuffle()
                feedbackLabel.setText(belowFeedback[0])
                
            } else if loggedReadings[0] > 150 { //above
                reading0Label.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
//                feedbackLabel.setText("Lower is power!")
                aboveFeedback.shuffle()
                feedbackLabel.setText(aboveFeedback[0])
            } else { //normal
                reading0Label.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
//                feedbackLabel.setText("You're amazing!")
                normalFeedback.shuffle()
                feedbackLabel.setText(normalFeedback[0])

            }
            date0Label.setText("On: \(loggedDates[0])")
        }
        reloadComplications()
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
    
    func saveAchievements(){
        defaults.set(loggedAchievements, forKey: Keys.savedAchievements)
        defaults.set(loggedAchDates, forKey: Keys.savedAchDates)
    }
    
    func saveConsecutiveDays(){
        defaults.set(loggedConsecutiveDays, forKey: Keys.savedConsecutiveDays)
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
        if applicationContext.keys.contains("readings"){
            loggedReadings = applicationContext["readings"] as! [Int]

        }
        
        if applicationContext.keys.contains("dates") {
            loggedDates = applicationContext["dates"] as! [String]

        }
        
        if applicationContext.keys.contains("ach") {
            loggedAchievements = applicationContext["ach"] as! [Bool]

        }
        
        if applicationContext.keys.contains("achDates") {
            loggedAchDates = applicationContext["achDates"] as! [String]

        }
        
        if applicationContext.keys.contains("consecutiveDays") {
            loggedConsecutiveDays = applicationContext["consecutiveDays"] as! Int

        }
        
        saveLoggedData()
        saveAchievements()
        saveConsecutiveDays()
        reloadComplications()

        
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
//                feedbackLabel.setText("Sugar! Please!")
                belowFeedback.shuffle()
                feedbackLabel.setText(belowFeedback[0])
            } else if loggedReadings[0] > 150 { //above
                reading0Label.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
//                feedbackLabel.setText("Lower is power!")
                aboveFeedback.shuffle()
                feedbackLabel.setText(aboveFeedback[0])
            } else { //normal
                reading0Label.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
//                feedbackLabel.setText("You're amazing!")
                normalFeedback.shuffle()
                feedbackLabel.setText(normalFeedback[0])
            }
            date0Label.setText("On: \(loggedDates[0])")
        }
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("RM")
        //        print(applicationContext["readings"])
        if message.keys.contains("readings"){
            loggedReadings = message["readings"] as! [Int]
        }
        
        if message.keys.contains("dates") {
            loggedDates = message["dates"] as! [String]

        }
        
        if message.keys.contains("ach") {
            loggedAchievements = message["ach"] as! [Bool]

        }
        
        if message.keys.contains("achDates") {
            loggedAchDates = message["achDates"] as! [String]

        }
        
        if message.keys.contains("consecutiveDays") {
            loggedConsecutiveDays = message["consecutiveDays"] as! Int

        }
        
        saveLoggedData()
        saveAchievements()
        saveConsecutiveDays()
        reloadComplications()
        
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
//                feedbackLabel.setText("Sugar! Please!")
                belowFeedback.shuffle()
                feedbackLabel.setText(belowFeedback[0])
            } else if loggedReadings[0] > 150 { //above
                reading0Label.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 33/255, blue: 33/255, alpha: 1.0))
//                feedbackLabel.setText("Lower is power!")
                aboveFeedback.shuffle()
                feedbackLabel.setText(aboveFeedback[0])
            } else { //normal
                reading0Label.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
                feedbackLabel.setTextColor(UIColor(red: 255/255, green: 222/255, blue: 3/255, alpha: 1.0))
//                feedbackLabel.setText("You're amazing!")
                normalFeedback.shuffle()
                feedbackLabel.setText(normalFeedback[0])
            }
            date0Label.setText("On: \(loggedDates[0])")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
