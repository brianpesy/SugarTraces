//
//  AddGlucoseViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 23/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import WatchConnectivity
import SAConfettiView
import AVFoundation
import HealthKit

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

let defaults = UserDefaults.standard

struct Keys {
    static let savedReadings = "savedReadings"
    static let savedDates = "savedDates"
    static let savedAchievements = "savedAchievements"
    static let savedAchDates = "savedAchDates"
    static let savedConsecutiveDays = "savedConsecutiveDays"
    static let savedName = "savedName"
}

class AddGlucoseViewController: UIViewController, WCSessionDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var achAudioPlayer: AVAudioPlayer!
    
    var loggedReadings = [Int]()
    var loggedDates = [String]()

    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)

    var loggedConsecutiveDays = 0
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    var wcSession: WCSession!
    @IBOutlet weak var glucoseInput: UITextField!
    @IBOutlet weak var feedback: UILabel!
    @IBOutlet weak var secondBox: UILabel!
    @IBOutlet weak var imageFeedback: UIImageView!
    @IBOutlet weak var sendAnim: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        //Initial animation and additional rendering for UIButton
        sendAnim.pulsate()
        sendAnim.layer.cornerRadius = sendAnim.frame.size.width/2
        sendAnim.textDropShadow()
        
        //Watch Connectivity
        self.wcSession = WCSession.default
        self.wcSession.delegate = self
        self.wcSession.activate()
        
//        print(wcSession.isReachable)
//        if wcSession.isReachable {
//            print("hahayes")
//        } else {
//            print("haha NO!")
//        }
        
        //Gives drop shadow to label
        feedback.textDropShadow()
        secondBox.textDropShadow()
        
        //Fixes wrapping of label if it gets too long
        feedback.numberOfLines = 0
//        feedback.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //Fixes font size issue
        feedback.minimumScaleFactor=0.5
        feedback.adjustsFontSizeToFitWidth = true
        feedback.lineBreakMode = .byClipping

        //Changes the text field style to rounded
        glucoseInput.layer.cornerRadius = 15.0
        glucoseInput.layer.borderWidth = 2.0
        glucoseInput.layer.borderColor = UIColor.gray.cgColor
        glucoseInput.clipsToBounds = true
        glucoseInput.placeholder = "In mg/dL"
        
        //Dismiss keyboard when tapped anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        loadLoggedData()
        loadAchievements()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
//        self.tabBarItem.title = "Add Glucose"
        
        
        let dingPath = Bundle.main.path(forResource: "DING.mp3", ofType: nil)
        let swooshPath = Bundle.main.path(forResource: "SWOOSH3.mp3", ofType: nil)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingPath!))
            achAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: swooshPath!))
        } catch {
            print(error)
        }
        
        print(loggedAchievements)
        print(loggedAchDates)
        
        loadConsecutiveDays()
        print(loggedConsecutiveDays)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendAnim.pulsate()
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
    
    func writeBloodGlucose(bloodGlucose: Double){
        
        let quantityType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)
        
        let quantityUnit = HKUnit(from: "mg/dL")
        
        let quantityAmount = HKQuantity(unit: quantityUnit, doubleValue: bloodGlucose)
        
        let now = Date()
        
        let sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: Date(), end: Date())
        
        healthKitStore.save(sample) { (success,error) in
            if success {
                print("successful")
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
            
            
            //sound clip for achievement
            achAudioPlayer.play()

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
                        achAudioPlayer.play()
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
                    achAudioPlayer.play()
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
                        achAudioPlayer.play()
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
                    achAudioPlayer.play()
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
            achAudioPlayer.play()
            
            //Achievement get
            loggedAchievements[5] = true
            
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[5] = formatter.string(from:date)
            
            saveAchievements()
            
        }
        
        //entered a normal reading after an above reading 6
        if (loggedReadings.indices.contains(1) && loggedAchievements[6] != true){
            if (loggedReadings[1] > 150 && loggedReadings[0] > 69 && loggedReadings[0] < 151){
                achAudioPlayer.play()
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
                
                saveAchievements()
            }
        }
        
        //entered a normal reading after a below reading 7
        if (loggedReadings.indices.contains(1) && loggedAchievements[7] != true){
            if (loggedReadings[1] < 70 && loggedReadings[0] > 69 && loggedReadings[0] < 151){
                achAudioPlayer.play()
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
                    achAudioPlayer.play()
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
                    
                    saveAchievements()
                }
            }
        }
    }
    
    @IBAction func send(_ sender: Any) {
        
        //Processing of the data, changing feedback depending on ranges, saving input and corresponding date to a dictionary.
        
        //Flash animation when pressed
        sendAnim.flash()
                
        //Empty case with nothing inputted or anything that is not a number
        if (glucoseInput.text == "" || Int(glucoseInput.text!) == nil){
            return
        }
        
        //sound clip
        audioPlayer.play()
        
        
        let num = Int(glucoseInput.text!)
        
        //Normal reading (70-150)
        if (num! > 69 && num! < 151) {
            //Changed the image
            imageFeedback.image = UIImage(named: "smile-g")
            
            //Shuffling in regards to what is inputted
            normalFeedback.shuffle()
            print(normalFeedback[0])
            feedback.text = normalFeedback[0]
            
            //Adding confetti to a normal reading
            let confettiView = SAConfettiView(frame: self.view.bounds)
            self.view.addSubview(confettiView)
                        
            //Confetti settings
            confettiView.intensity = 0.2
            confettiView.startConfetti()
                        
            
            //Delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                confettiView.stopConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    confettiView.removeFromSuperview()
                    
                }
            }
            
            //Consecutive day check
            if (loggedConsecutiveDays == 0){
                loggedConsecutiveDays = 1
                saveConsecutiveDays()
                print(loggedConsecutiveDays)
            } else {
                //do the function
//                loggedConsecutiveDays = consecutiveDaysCheck(prevDay: loggedDates[1], newDay: loggedDates[0], consecutiveDays: loggedConsecutiveDays)
                loggedConsecutiveDays = consecutiveDaysCheck(prevDay: "02-29-2020 14:23:53", newDay: "03-01-2020 14:23:53", consecutiveDays: loggedConsecutiveDays)

//                print(loggedConsecutiveDays)
                saveConsecutiveDays()
            }
            
        }
        //Below reading (below 70)
        else if (num! < 70){
            imageFeedback.image = UIImage(named: "sad-g")
            
            //feedback
            belowFeedback.shuffle()
            feedback.text = belowFeedback[0]
            
            //Consecutive day check
            if (loggedConsecutiveDays != 0){
                loggedConsecutiveDays = 0
                saveConsecutiveDays()
                print(loggedConsecutiveDays)

            }
                                    
        }
        //Above reading (above 150)
        else if (num! > 150){
            imageFeedback.image = UIImage(named: "angry-g")
            
            //feedback
            aboveFeedback.shuffle()
            feedback.text = aboveFeedback[0]
            
            //Consecutive day check
            if (loggedConsecutiveDays != 0){
                loggedConsecutiveDays = 0
                saveConsecutiveDays()
                print(loggedConsecutiveDays)

            }
        }
        
        //Put data in array
        let date = Date()
        let formatter = DateFormatter()
        //Date formatting
        formatter.timeZone = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        loggedReadings.insert(num!, at: 0)
        loggedDates.insert(formatter.string(from:date), at:0)
        
        //Save Data
        saveLoggedData()
        
        //Saving to HealthKit
        writeBloodGlucose(bloodGlucose: Double(num!))
        
        //Achievement check
        achievementCheck()
        
        glucoseInput.text = ""
        
        print(loggedReadings)
        print(loggedDates)
        
        
        //Watch Connectivity part
        
        //This can check if the watch is reachable. It'll have an error if it isn't!
        print(wcSession.isReachable)

        //SAVING IS NOT WORKING YET
        
        //I need my values to have a key! This is a dictionary
        let strReadings = "\(loggedReadings)"
        let strDates = "\(loggedDates)"
        let readings = ["readings": strReadings, "dates": strDates]
        
        //when I send a message over with the Text Field, I can send it to the WC Session.
        //the same command for watch to iOS as well!
        wcSession.sendMessage(readings, replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
