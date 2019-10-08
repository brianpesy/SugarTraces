//
//  PopupViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 08/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    var clickedAch = ""
    var descriptions = ["You entered your first reading!",
    "You entered 4 consecutive readings after an above normal reading!",
    "You entered 5 consecutive normal readings!",
    "You entered 4 consecutive normal readings after a below normal reading!",
    "You entered 10 consecutive readings!",
    "You entered normal readings for 3 days in a row!",
    "You entered a normal reading after an above reading!",
    "You entered a normal reading after a below reading!",
    "You entered 15 consecutive normal readings!",
    "You checked out the Send Data option. Thanks!",
    "You checked out the Acknowledgment option. Thanks!"]
    var loggedAchDates = [String](repeating: "", count: 11)

    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var achDescription: UILabel!
    @IBOutlet weak var achDateObtained: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //clickedAch has our variable that we clicked
        print(clickedAch)
        loadAchievements()
        achDescription.text = "\(descriptions[Int(clickedAch)!])\nObtained: \(loggedAchDates[Int(clickedAch)!])"
        
    }
    
    func loadAchievements(){
        var savedAchDates = defaults.array(forKey: Keys.savedAchDates) as? [String] ?? [String]()
        loggedAchDates = savedAchDates
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
