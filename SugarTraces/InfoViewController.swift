//
//  InfoViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

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
