//
//  AchievementInterfaceController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 10/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class AchievementInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var consecutiveDaysLabel: WKInterfaceLabel!
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    let defaults = UserDefaults.standard

    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    var loggedConsecutiveDays = 0
    
    var wcSession: WCSession!

    
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
        
//        loadTableData()
    }
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
        
        loadAchievements()
        loadConsecutiveDays()
        
        var strLoggedConsecutiveDays = String(loggedConsecutiveDays)
        
        
        consecutiveDaysLabel.setText("Days straight: \(strLoggedConsecutiveDays)")

        //loading of the table of achievements will go in here
        
        loadTableData()

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
    
    func saveAchievements(){
        defaults.set(loggedAchievements, forKey: Keys.savedAchievements)
        defaults.set(loggedAchDates, forKey: Keys.savedAchDates)
    }
    
    func saveConsecutiveDays(){
        defaults.set(loggedConsecutiveDays, forKey: Keys.savedConsecutiveDays)
    }
    
    func loadTableData() {
        
        tableView.setNumberOfRows(loggedAchievements.count, withRowType: "RowController")
        
        for (index, element) in loggedAchievements.enumerated() {
            print(element)
            if let rowController = tableView.rowController(at: index) as? RowController {
//                rowController.achLabel.setText(String(element))
                
                //we can change the text to the description here... array of descriptions!
                //also, array of strings that correspond to the image's filename
                
                if element == true {
                    rowController.achLabel.setText("Achievement")
                } else if element == false {
                    rowController.achLabel.setText("Locked")
                }
            }
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        //context is the data we're passing over. We'll pass the rowIndex number instead.
        pushController(withName: "DetailInterfaceController", context: loggedAchievements[rowIndex])
    }
    
}
