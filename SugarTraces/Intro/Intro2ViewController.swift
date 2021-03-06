//
//  Intro2ViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 05/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

class Intro2ViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = 1


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
        pageControl.currentPage = 1
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            print("Swipe Right")
        
            //do segue
            performSegue(withIdentifier: "backSegue", sender: self)
       }
       else if gesture.direction == .left {
            print("Swipe Left")
        
            //do segue
            performSegue(withIdentifier: "nextSegue", sender: self)

            
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
