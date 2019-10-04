////
////  IntroViewController.swift
////  SugarTraces
////
////  Created by Brian Sy on 03/10/2019.
////  Copyright © 2019 Brian Sy. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//class IntroViewController: UIViewController {
//
////    var pages = [UIViewController]()
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        self.delegate = self
////        self.dataSource = self
////
////        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intro1ID")
////        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intro2ID")
////        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intro3ID")
////
////        // etc ...
////
////        pages.append(p1)
////        pages.append(p2)
////        pages.append(p3)
////
////        // etc ...
////
////        setViewControllers([p1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
////    }
//
////    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
////
////        let cur = pages.index(of: viewController)!
////
////        // if you prefer to NOT scroll circularly, simply add here:
////        // if cur == 0 { return nil }
////
////        let prev = abs((cur - 1) % pages.count)
////        return pages[prev]
////
////    }
////
////    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
////
////        let cur = pages.index(of: viewController)!
////
////        // if you prefer to NOT scroll circularly, simply add here:
////        // if cur == (pages.count - 1) { return nil }
////
////        let nxt = abs((cur + 1) % pages.count)
////        return pages[nxt]
////    }
////
////    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
////        return pages.count
////    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
