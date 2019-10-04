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


class InfoViewController: UIViewController {

    @IBOutlet weak var bgBox: UILabel!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var ackBtn: UIButton!
    @IBOutlet weak var tpBtn: UIButton!
    @IBOutlet weak var sendDataOutlet: UIButton!
    
    var loggedReadings = [Int]()
    var loggedDates = [String]()
    
    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    var dob:Any?
    var sex:Any?
    
    var achAudioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgBox.textDropShadow()
        // Do any additional setup after loading the view.
        
        //animate buttons
//        aboutBtn.pulsate()
//        ackBtn.pulsate()
//        tpBtn.pulsate()
        
        //change appearance of the sendDataOutlet
        sendDataOutlet.layer.cornerRadius = 13
        sendDataOutlet.pulsate()

//        sendDataOutlet.layer.borderWidth = 1
//        sendDataOutlet.layer.borderColor = UIColor.gray.cgColor
        
        let swooshPath = Bundle.main.path(forResource: "SWOOSH3.mp3", ofType: nil)
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
    
    @IBAction func sendData(_ sender: Any) {
        
        (dob, sex) = readProfile()
                
        loadLoggedData()
        
        sendEmail()
        
        if (loggedAchievements[9] != true){
            achAudioPlayer.play()
            print("ACHIEVEMENT")
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
        }
        
        
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
        
    //sending export data through email: wsl-research@dcs.upd.edu.ph || bpsy@up.edu.ph
    
    // Data consists of: date of birth, blood glucose levels and dates, and sex. HealthKit functionality required.
    // Subject: SugarTraces Health Data
        
      if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
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
            print(dateOfBirth)
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
            
            print(sexInp)
        } catch {
            print("Error in getting sex")
        }
        
        return (dateOfBirth, sexInp)
    }

    @IBAction func acknowledgementBtn(_ sender: Any) {
        
        if (loggedAchievements[10] != true){
            achAudioPlayer.play()
            print("ACHIEVEMENT")
            //Achievement get
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
