//
//  MasterTabBarViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 23/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import MMTabBarAnimation

//tab bar view controller

class MasterTabBarViewController: MMTabBarAnimateController {
    
    var name = "f"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        //if name name == "", we start the app with the segue to the intro. If not, we don't have to.
        
        if (name == "") {
            performSegue(withIdentifier: "introSegue", sender: self)
            name = "p"
            print("in")
        }
        navigationItem.hidesBackButton = true

                
        //initial tab bar button is Add Glucose
        self.selectedIndex = 2
        // Do any additional setup after loading the view.

        //animation for clicking home (0)
        super.setAnimate(index: 0, animate: .icon(type: .jump))
        
        //animation for clicking stats (1)
        super.setAnimate(index: 1, animate: .icon(type: .rotation (type: .right)))

        //animation for clicking add glucose (2)
        super.setAnimate(index: 2, animate: .icon(type: .scale(rate: 1.2)))
        
        //animation for clicking achievements (3)
        super.setAnimate(index: 3, animate: .icon(type: .rotation (type: .left)))
        
        //animation for clicking info (4)
        super.setAnimate(index: 4, animate: .icon(type: .jump))

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
