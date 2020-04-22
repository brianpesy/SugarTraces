//
//  AchievementsViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import WatchConnectivity

class AchievementsViewController: UIViewController, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("%@", "sessionDidBecomeInactive: \(session)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("%@", "sessionDidDeactivate: \(session)")
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("%@", "sessionWatchStateDidChange: \(session)")
    }
    

    var wcSession: WCSession!
    
    var loggedAchievements = [Bool](repeating: false, count: 11)
    var loggedAchDates = [String](repeating: "", count: 11)
    
    var transferToWatch: [String: [Any]] = [:]
    
    var clickedAch = ""
    
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
        
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
        
        loadAchievements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAchievements()
        
        if loggedAchievements.isEmpty {
            loggedAchievements = [Bool](repeating: false, count: 11)
        }
        if loggedAchDates.isEmpty {
            loggedAchDates = [String](repeating: "", count: 11)
        }
        
        
        transferToWatch = ["ach": loggedAchievements, "achDates": loggedAchDates]

        //synchronization with watch
        if wcSession.isReachable {
            print("reach")
            wcSession.sendMessage(transferToWatch, replyHandler: nil, errorHandler: {error in
                do {
                    try self.wcSession.updateApplicationContext(self.transferToWatch)

                } catch {
                    print(error.localizedDescription)
                }
            })

        }
        
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
    
    @IBAction func achBtn0(_ sender: Any) {
        print("btn0")
        if (loggedAchievements[0] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering your first reading!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "0"
        performSegue(withIdentifier: "achSegue", sender: self)
        
    }
    
    @IBAction func achBtn1(_ sender: Any) {
        print("btn1")
        if (loggedAchievements[1] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering 4 consecutive readings after an above normal readings!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "1"
        performSegue(withIdentifier: "achSegue", sender: self)
    }
    
    @IBAction func achBtn2(_ sender: Any) {
        print("btn2")
        if (loggedAchievements[2] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering 5 consecutive normal readings!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "2"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn3(_ sender: Any) {
        print("btn3")
        if (loggedAchievements[3] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering 4 consecutive normal readings after a below normal reading!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "3"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn4(_ sender: Any) {
        print("btn4")
        if (loggedAchievements[4] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering 10 consecutive readings!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "4"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn5(_ sender: Any) {
        print("btn5")
        if (loggedAchievements[5] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering normal readings for 3 days in a row!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "5"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn6(_ sender: Any) {
        print("btn6")
        if (loggedAchievements[6] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering a normal reading after an above reading!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "6"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn7(_ sender: Any) {
        print("btn7")
        if (loggedAchievements[7] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering a normal reading after a below reading!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "7"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn8(_ sender: Any) {
        print("btn8")
        if (loggedAchievements[8] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try entering 15 consecutive normal readings!", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "8"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn9(_ sender: Any) {
        print("btn9")
        if (loggedAchievements[9] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try checking out the Send Data option.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "9"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    @IBAction func achBtn10(_ sender: Any) {
        print("btn10")
        if (loggedAchievements[10] == false) {
            // create the alert
            let alert = UIAlertController(title: "Achievement locked!", message: "Try checking out the Acknowledgment option.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        clickedAch = "10"
        performSegue(withIdentifier: "achSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! PopupViewController
        vc.clickedAch = self.clickedAch
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
