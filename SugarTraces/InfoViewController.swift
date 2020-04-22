//
//  InfoViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import HealthKit
import MessageUI
import AVFoundation
import WatchConnectivity



class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate, WCSessionDelegate {
    
    var wcSession: WCSession!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

    @IBOutlet weak var bgBox: UILabel!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var ackBtn: UIButton!
    @IBOutlet weak var tpBtn: UIButton!
    @IBOutlet weak var sendDataOutlet: UIButton!
    
    var loggedReadings = [Int]()
    var loggedDates = [String]()
    
    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    var transferToWatch: [String: [Any]] = [:]
    
    var dob:Any?
    var sex:Any?
    
    var achAudioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Watch Connectivity
        self.wcSession = WCSession.default
        self.wcSession.delegate = self
        self.wcSession.activate()
        
        bgBox.textDropShadow()
        // Do any additional setup after loading the view.

        
        //change appearance of the sendDataOutlet
        sendDataOutlet.layer.cornerRadius = 13
        sendDataOutlet.pulsate()

        
        let swooshPath = Bundle.main.path(forResource: "achivement.mp3", ofType: nil)
        do {
            achAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: swooshPath!))
        } catch {
            print(error)
        }
        
        loadAchievements()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendDataOutlet.pulsate()
    }
    
    //send data functionality, getting information for dob and sex
    @IBAction func sendData(_ sender: Any) {
        
        (dob, sex) = readProfile()
                
        loadLoggedData()
                
        if (loggedAchievements[9] != true){
            achAudioPlayer.play()
            //Achievement get
            loggedAchievements[9] = true
            
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[9] = formatter.string(from:date)
            
            saveAchievements()
            
        } else {
            print("went in")
            
            loggedAchievements[9] = true
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[9] = formatter.string(from:date)
            
            saveAchievements()
        }
                    
        //sync
        transferToWatch = ["ach": loggedAchievements, "achDates": loggedAchDates]
        
        wcSession.sendMessage(transferToWatch, replyHandler: nil, errorHandler: {error in
//                print(error.localizedDescription)
            do {
                try self.wcSession.updateApplicationContext(self.transferToWatch)

            } catch {

                print(error.localizedDescription)
            }
        })
        
        sendEmail()

        
        
    }
    
    func loadAchievements(){
        var savedAchievements = defaults.array(forKey: Keys.savedAchievements) as? [Bool] ?? [Bool]()
        loggedAchievements = savedAchievements
        
        var savedAchDates = defaults.array(forKey: Keys.savedAchDates) as? [String] ?? [String]()
        loggedAchDates = savedAchDates
    }
    
    func saveAchievements(){
        defaults.set(loggedAchievements, forKey: Keys.savedAchievements)
        defaults.set(loggedAchDates, forKey: Keys.savedAchDates)
    }

    func sendEmail() {
        
    //sending export data through email: bpsy@up.edu.ph
    
    // Data consists of: date of birth, blood glucose levels and dates, and sex. HealthKit functionality required.
    // Subject: SugarTraces Health Data
        
      if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        mail.setToRecipients(["bpsy@up.edu.ph"])
        mail.setSubject("SugarTraces Health Data")
        
        var messageBody = [String]()
        
        messageBody.append(String(describing: dob!))
        
        messageBody.append(String(describing: sex!))

        var stringArray = loggedReadings.map { String($0) }
        var loggedReadingsStr = stringArray.joined(separator: "..")
        messageBody.append(loggedReadingsStr)
        
        var loggedDatesStr = loggedDates.joined(separator: "..")
        messageBody.append(loggedDatesStr)

        mail.setMessageBody(messageBody.joined(separator:"|"), isHTML: true)

        present(mail, animated: true)
      } else {
        // show failure alert
      }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "Mail not sent")")
        default:
            break
        }
          self.dismiss(animated: true, completion: nil)
      }
    
    func loadLoggedData(){
        
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
    
    func readProfile() -> (dob:Any?, sex:Any?){
        
        var dateOfBirth:Any?
        var sexInp:Any?
        
        var biologicalSexObject: HKBiologicalSexObject?
        var biologicalSex: HKBiologicalSex?
        
        do {
            dateOfBirth = try healthKitStore.dateOfBirthComponents()
            dateOfBirth = try healthKitStore.dateOfBirth()
        } catch {
            print("Error in getting date of birth")
        }
        
        do { //Get the sex of the person
            biologicalSexObject = try healthKitStore.biologicalSex()
            biologicalSex = biologicalSexObject!.biologicalSex
            
            switch biologicalSex!.rawValue{
                case 0:
                    sexInp = nil
                case 1:
                    sexInp = "Female"
                case 2:
                    sexInp = "Male"
                case 3:
                    sexInp = "Other"
                default:
                    sexInp = nil
            }
            
        } catch {
            print("Error in getting sex")
        }
        
        return (dateOfBirth, sexInp)
    }

    @IBAction func acknowledgementBtn(_ sender: Any) {
        
        if (loggedAchievements[10] != true){
            achAudioPlayer.play()
            //Achievement get
            loggedAchievements[10] = true
            
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[10] = formatter.string(from:date)
            
            // create the alert
            let alert = UIAlertController(title: "Woah! An achievement!", message: "You checked out the Acknowledgment option. Thanks! Check out the achievement tab", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: { action in
                    self.performSegue(withIdentifier: "ackSegue", sender: self)
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            saveAchievements()
            
        } else {
            
            loggedAchievements[10] = true
            let date = Date()
            let formatter = DateFormatter()
            //Date formatting
            formatter.timeZone = .current
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            
            //Date when achievement was gotten
            loggedAchDates[10] = formatter.string(from:date)
            
            saveAchievements()
        }
        
        transferToWatch = ["ach": loggedAchievements, "achDates": loggedAchDates]
        wcSession.sendMessage(transferToWatch, replyHandler: nil, errorHandler: {error in
            do {
                try self.wcSession.updateApplicationContext(self.transferToWatch)

            } catch {
                print(error.localizedDescription)
            }
        })
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
