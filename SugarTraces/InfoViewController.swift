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

class InfoViewController: UIViewController {

    @IBOutlet weak var bgBox: UILabel!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var ackBtn: UIButton!
    @IBOutlet weak var tpBtn: UIButton!
    @IBOutlet weak var sendDataOutlet: UIButton!
    
    var loggedReadings = [Int]()
    var loggedDates = [String]()
    
    var dob:Any?
    var sex:Any?
    
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendDataOutlet.pulsate()
    }
    
    @IBAction func sendData(_ sender: Any) {
        
        (dob, sex) = readProfile()
                
        loadLoggedData()
        
        sendEmail()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
