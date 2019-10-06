//
//  Intro1ViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 04/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit

class Intro3fViewController: UIViewController {

    var name = ""
    
    
    var images = ["intro1", "intro2", "intro3"]
    var descriptions = ["1","2","3"]
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        pageControl.numberOfPages = 3
//        pageControl.pageIndicatorTintColor = UIColor.darkGray
//        pageControl.currentPage = 3
        //pageControl.currentPage = Int(pageNumber)
//        for index in 0..<images.count {
//            frame.origin.x = scrollView.frame
//        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (name != "") {
            performSegue(withIdentifier: "toMainSegue", sender: self)
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            print("Swipe Right")
            //page dot control
            if pageNumber != 0 {
                pageNumber = pageNumber - 1
            }
            print(pageNumber)
//            pageControl.currentPage = Int(pageNumber)
        
            //do segue
//            descLabel.text = descriptions[Int(pageNumber)]
       }
       else if gesture.direction == .left {
            print("Swipe Left")
            //page dot control
            if pageNumber != 2 {
                pageNumber = pageNumber + 1
            }
            print(pageNumber)
//            pageControl.currentPage = Int(pageNumber)
        
            //do segue
            
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
