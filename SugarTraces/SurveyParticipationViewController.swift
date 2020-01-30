//
//  SurveyParticipationViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 30/01/2020.
//  Copyright © 2020 Brian Sy. All rights reserved.
//

import UIKit
import ResearchKit

class SurveyParticipationViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    var surveyStart = false
    @IBOutlet weak var consentBtn: UIButton!

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        //this seems to make it true even if the person presses cancel instead of done at the very end
//        taskViewController.dismiss(animated: true, completion: {() in self.consentDone = true})
        taskViewController.dismiss(animated: true, completion: nil)

        switch (reason) {
          case .completed:
            
            //extracting the results from the survey
              let taskResult = taskViewController.result.results
              print(taskResult)
              
              for stepResults in taskResult! as! [ORKStepResult]{
                  print("---")
                  for result in stepResults.results! {
                    
                    //Check if consent is done. consentDone = true means YES!
                    if result.identifier == "UserSignature"{
                        print(result)
                        let consentDoneAnswerResult = result as! ORKConsentSignatureResult
                        let consentDone = consentDoneAnswerResult.consented
                        surveyStart = consentDone
                        print(consentDone)
                        consentBtn.setTitle("Leave Research", for: .normal)
                        consentBtn.titleLabel?.adjustsFontSizeToFitWidth = true

                        
                        //now locally save the status of consent on the phone that the consent is done
                        
                        
                    }
                    
                    //extracting the answers from the survey itself now using the identifiers
                    
                    if result.identifier == "NameStep"{
                        print(result)
                        let nameAnswerResult = result as! ORKTextQuestionResult
                        let name = nameAnswerResult.answer!
                        print(name)

                    }
                    
                    if result.identifier == "Breathing"{
                         print(result)
                    }
                  }
              }
            
        case .saved:
            break
        case .discarded:
            break
        case .failed:
            break
        @unknown default:
            break
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //consent task
    @IBAction func consentTask(_ sender: Any) {
        if surveyStart == false {
            let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        }
        else if surveyStart == true {
            //alert if they want to stop

        }
    }
    
    //survey task
    @IBAction func surveyTask(_ sender: Any) {
        if surveyStart == true {
            let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        }
        else if surveyStart == false {
            //alert that they need consent first before starting
            
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
