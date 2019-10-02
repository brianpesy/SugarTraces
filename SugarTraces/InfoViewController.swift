//
//  InfoViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import HealthKit

class InfoViewController: UIViewController {

    @IBOutlet weak var bgBox: UILabel!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var ackBtn: UIButton!
    @IBOutlet weak var tpBtn: UIButton!
    @IBOutlet weak var sendDataOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgBox.textDropShadow()
        // Do any additional setup after loading the view.
        
        //animate buttons
        aboutBtn.pulsate()
        ackBtn.pulsate()
        tpBtn.pulsate()
        
        //change appearance of the sendDataOutlet
        
        
    }
    
    @IBAction func sendData(_ sender: Any) {
        //sending export data through email: wsl-research@dcs.upd.edu.ph
        
        // Data consists of: date of birth, blood glucose levels and dates, and sex. HealthKit functionality required.
        // Subject: SugarTraces Health Data
        let (dob, sex, bloodGlucose) = readProfile()
        print(dob, sex)
    }
    
    
    func readProfile() -> (dob:Any?, sex:Any?, bloodGlucose:Any?){
        
        var dateOfBirth:Any?
        var sexInp:Any?
        var bloodglucose:Any?
        
        var biologicalSexObject: HKBiologicalSexObject?
        var biologicalSex: HKBiologicalSex?
        
        do {
            dateOfBirth = try healthKitStore.dateOfBirthComponents()
            dateOfBirth = try healthKitStore.dateOfBirth()
            print(dateOfBirth)
        } catch {
            print("nuh")
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
            print("nuh2")
        }
        
        do {
            //blood glucose reading here
            
//            bloodglucose = try healthKitStore.
        }
        
//        return ("d","e")
        return (dateOfBirth, sexInp, bloodglucose)
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
