//
//  HomeViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {
    
    var loggedName = ""

    var loggedReadings = [Int]()
    var loggedDates = [String]()

    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)

    var loggedConsecutiveDays = 0
    
//    @IBOutlet weak var firstBox: UILabel!
    @IBOutlet weak var secondBox: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readingNumLabel: UILabel!
    @IBOutlet weak var lastReadingLabel: UILabel!
    @IBOutlet weak var achNumLabel: UILabel!
    @IBOutlet weak var consecutiveDaysLabel: UILabel!
    
    
    
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
    
    func loadName(){
        var savedName = defaults.string(forKey: Keys.savedName)
        loggedName = savedName ?? "User"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.textDropShadow()
        secondBox.textDropShadow()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadLoggedData()
        loadAchievements()
        loadConsecutiveDays()
        loadName()
                
//        print(loggedName)
        nameLabel.text = loggedName
        print(loggedReadings)
        readingNumLabel.text = "Recorded readings: \(loggedReadings.count)"
        print(loggedDates)
        if loggedReadings.indices.contains(0){
            if loggedReadings[0] < 70 {
                lastReadingLabel.text = "Last reading at \(loggedDates[0]), below"
            } else if loggedReadings[0] > 150 {
                lastReadingLabel.text = "Last reading at \(loggedDates[0]), above"
            } else if loggedReadings[0] > 69 && loggedReadings[0] < 151 {
                lastReadingLabel.text = "Last reading at \(loggedDates[0]), normal"
            }
        } else {
            lastReadingLabel.text = "No readings yet!"
        }
        print(loggedAchievements)
        print(loggedAchDates)
        print(loggedConsecutiveDays)
        var ctr = 0
        for val in loggedAchievements {
            if val == true {
                ctr = ctr + 1
            }
        }
        
        achNumLabel.text = "Achievements unlocked: \(ctr)"
        
        consecutiveDaysLabel.text = "Consecutive Days: \(loggedConsecutiveDays)"
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
