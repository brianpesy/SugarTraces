//
//  AchievementsViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    @IBOutlet weak var ach0: UIImageView!
    @IBOutlet weak var ach1: UIImageView!
    @IBOutlet weak var ach2: UIImageView!
    @IBOutlet weak var ach3: UIImageView!
    @IBOutlet weak var ach4: UIImageView!
    @IBOutlet weak var ach5: UIImageView!
    @IBOutlet weak var ach6: UIImageView!
    @IBOutlet weak var ach7: UIImageView!
    @IBOutlet weak var ach8: UIImageView!
    @IBOutlet weak var ach9: UIImageView!
    @IBOutlet weak var ach10: UIImageView!
    
    func loadAchievements(){
        var savedAchievements = defaults.array(forKey: Keys.savedAchievements) as? [Bool] ?? [Bool]()
        loggedAchievements = savedAchievements
        
        var savedAchDates = defaults.array(forKey: Keys.savedAchDates) as? [String] ?? [String]()
        loggedAchDates = savedAchDates
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAchievements()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
        
        print(loggedAchievements)
        print(loggedAchDates)
        
        //Change the icons of each achievement according to the loggedAchievements and loggedAchDates, both of which are of indices 0-10, corresponding to a specific achievement
        if (loggedAchievements[0] == true){
            ach0.image = UIImage(named: "imgAch0")
        }
        if (loggedAchievements[1] == true){
            ach1.image = UIImage(named: "imgAch1")
        }
        if (loggedAchievements[2] == true){
            ach2.image = UIImage(named: "imgAch2")
        }
        if (loggedAchievements[3] == true){
            ach3.image = UIImage(named: "imgAch3")
        }
        if (loggedAchievements[4] == true){
            ach4.image = UIImage(named: "imgAch4")
        }
        if (loggedAchievements[5] == true){
            ach5.image = UIImage(named: "imgAch5")
        }
        if (loggedAchievements[6] == true){
            ach6.image = UIImage(named: "imgAch6")
        }
        if (loggedAchievements[7] == true){
            ach7.image = UIImage(named: "imgAch7")
        }
        if (loggedAchievements[8] == true){
            ach8.image = UIImage(named: "imgAch8")
        }
        if (loggedAchievements[9] == true){
            ach9.image = UIImage(named: "imgAch9")
        }
        if (loggedAchievements[10] == true){
            ach10.image = UIImage(named: "imgAch10")
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
