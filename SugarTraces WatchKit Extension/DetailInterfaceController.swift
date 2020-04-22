//
//  DetailInterfaceController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 19/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController: WKInterfaceController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var imgAch: WKInterfaceImage!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    var imgArr = ["imgAch0", "imgAch1", "imgAch2", "imgAch3", "imgAch4", "imgAch5", "imgAch6", "imgAch7", "imgAch8", "imgAch9", "imgAch10"]
    var descriptionArr = ["Entered your first reading!", "Entered 4 consecutive readings after an above normal reading!", "Entered 5 consecutive normal readings!", "Entered 4 consecutive normal readings after a below normal reading!", "Entered 10 consecutive readings!", "Entered normal readings for 3 days in a row!", "Entered a normal reading after an above reading!", "Entered a normal reading after a below reading!", "Entered 15 consecutive normal readings!", "Checked out the Send Data option!", "Checked out the Acknowledgment option!"]
    var lockedDescriptionArr = ["Try entering your first reading!", "Try entering 4 consecutive readings after an above normal readings!", "Try entering 5 consecutive normal readings!", "Try entering 4 consecutive normal readings after a below normal reading!", "Try entering 10 consecutive readings!", "Try entering normal readings for 3 days in a row!", "Try entering a normal reading after an above reading!", "Try entering a normal reading after a below reading!", "Try entering 15 consecutive normal readings!", "Try checking out the Send Data option.", "Try checking out the Acknowledgment option."]
    
    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loadAchievements()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
        
        print(loggedAchDates)
        
        if let detailData = context as? [Int] {
            
            //we can start doing our operations in here. We passed if the achievement is 1 or 0 (1: true, 0: false). We can base the deatil off this value.
            //detailData[0] is if the achievement is true or false
            //detailData[1] is which achievement was picked
            
            print(detailData)
            
            if detailData[0] == 0 {
                imgAch.setImage(UIImage(named: "lock"))
                
                //Locked descriptions here.
                detailLabel.setText("Locked")
                
                //Empty dateLabel required.
                dateLabel.setText(lockedDescriptionArr[detailData[1]])
            } else if detailData[0] == 1 {
                //image of the unlocked achievement here
                imgAch.setImage(UIImage(named: imgArr[detailData[1]]))
                
                //Unlocked descriptions here.
                detailLabel.setText(descriptionArr[detailData[1]])
                //dateLabel required
                dateLabel.setText("Unlocked on:\n \(loggedAchDates[detailData[1]])")
            }
            
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func loadAchievements(){
        var savedAchievements = defaults.array(forKey: Keys.savedAchievements) as? [Bool] ?? [Bool]()
        loggedAchievements = savedAchievements
        
        var savedAchDates = defaults.array(forKey: Keys.savedAchDates) as? [String] ?? [String]()
        loggedAchDates = savedAchDates
    }
    
}
