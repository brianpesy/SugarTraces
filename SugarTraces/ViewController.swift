//
//  ViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 05/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import HealthKit

let healthKitStore:HKHealthStore = HKHealthStore()

class ViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startBtnOutlet: UIButton!
    
    var loggedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        nameTextField.layer.cornerRadius = 15.0
        nameTextField.layer.borderWidth = 2.0
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.clipsToBounds = true
        nameTextField.placeholder = "Your name here"
        
        startBtnOutlet.layer.cornerRadius = 13
        
        authorize()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startBtnOutlet.pulsate()
    }
    
    @IBAction func nameEnterBtn(_ sender: Any) {
        if (nameTextField.text == ""){
            loggedName = "User"
        } else {
            loggedName = nameTextField.text!
        }
        saveName()
    }
    
    func saveName(){
        defaults.set(loggedName, forKey: Keys.savedName)
    }
    
    
    func authorize(){
        let healthKitTypesToRead : Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        ]
        
        let healthKitTypesToWrite : Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        ]
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Error occured")
            return
        }
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) -> Void in
            print("Read-Write authorization success")
        }
        
    }
    
}

