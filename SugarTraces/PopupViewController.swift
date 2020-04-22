//
//  PopupViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 08/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

//when clicking on an achievement, this appears

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
    var isFront = true

    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var achDescription: UILabel!
    @IBOutlet weak var achDateObtained: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView.isHidden = false
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //clickedAch has our variable that we clicked
        loadAchievements()
        achDescription.text = "Description:\n\(descriptions[Int(clickedAch)!])"
        
    }
    
    func loadAchievements(){
        var savedAchDates = defaults.array(forKey: Keys.savedAchDates) as? [String] ?? [String]()
        loggedAchDates = savedAchDates
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func flipPopup(_ sender: Any) {
        if isFront == true {
            isFront = false
            UIView.transition(with: popupView, duration: 1.0, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            achDescription.text = "Obtained:\n\(loggedAchDates[Int(clickedAch)!])\nCongrats!"

        } else {
            isFront = true
            UIView.transition(with: popupView, duration: 1.0, options: .transitionFlipFromRight, animations: nil, completion: nil)
            achDescription.text = "Description:\n\(descriptions[Int(clickedAch)!])"

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
