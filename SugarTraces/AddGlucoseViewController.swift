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
}

class AddGlucoseViewController: UIViewController, WCSessionDelegate {
    
    var loggedReadings = [Int]()
    var loggedDates = [String]()
    
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
        glucoseInput.placeholder = "Tap here to type"
        
        //Dismiss keyboard when tapped anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        loadLoggedData()
                
//        self.tabBarItem.title = "Add Glucose"
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
    
    @IBAction func send(_ sender: Any) {
        
        //Processing of the data, changing feedback depending on ranges, saving input and corresponding date to a dictionary.
        
        //Flash animation when pressed
        sendAnim.flash()
        
        //Empty case with nothing inputted or anything that is not a number
        if (glucoseInput.text == "" || Int(glucoseInput.text!) == nil){
            return
        }
        
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
            
            //Sound clip
            
            
            //Delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                confettiView.stopConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    confettiView.removeFromSuperview()
                    
                }
            }
        }
        //Below reading (below 70)
        else if (num! < 70){
            imageFeedback.image = UIImage(named: "sad-g")
            
            //feedback
            belowFeedback.shuffle()
            feedback.text = belowFeedback[0]
            
            //sound
                        
        }
        //Above reading (above 150)
        else if (num! > 150){
            imageFeedback.image = UIImage(named: "angry-g")
            
            //feedback
            aboveFeedback.shuffle()
            feedback.text = aboveFeedback[0]
            
            //sound
            
            
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
