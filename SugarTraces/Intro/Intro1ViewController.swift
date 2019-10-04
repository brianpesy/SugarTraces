//
//  Intro1ViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 04/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

class Intro1ViewController: UIViewController {

    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (name != "") {
            performSegue(withIdentifier: "toMainSegue", sender: self)
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
