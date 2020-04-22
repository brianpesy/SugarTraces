//
//  Intro1ViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 05/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

//intro view controller

class Intro1ViewController: UIViewController {
    
    var loggedName = ""
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = 0


        // Do any additional setup after loading the view.
        
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pageControl.currentPage = 0
        loadName()
        if (loggedName != "") {
            performSegue(withIdentifier: "toMainSegue", sender: self)
        }
    }
    
    func loadName(){
        var savedName = defaults.string(forKey: Keys.savedName)
        loggedName = savedName ?? ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            print("Swipe Right")
        
            //do segue
        
       }
       else if gesture.direction == .left {
            print("Swipe Left")
        
            //do segue
            performSegue(withIdentifier: "nextSegue", sender: self)

            
       }
    }

    

}
