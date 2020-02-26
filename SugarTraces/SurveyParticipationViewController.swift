//
//  SurveyParticipationViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 30/01/2020.
//  Copyright © 2020 Brian Sy. All rights reserved.
//

import UIKit
import ResearchKit
import MessageUI


class SurveyParticipationViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    var surveyStart = false
    @IBOutlet weak var consentBtn: UIButton!
    var answers = [String:String]()
    
    
    let defaults = UserDefaults.standard
    
    func saveSurveyStart(){
        defaults.set(surveyStart, forKey: Keys.savedSurveyStart)
        print("saved")
    }
    
    func loadSurveyStart(){
//        var savedSurveyStart = (defaults.array(forKey: Keys.savedAchievements) != nil) as Bool
        var savedSurveyStart = defaults.bool(forKey: Keys.savedSurveyStart)
        print("-START-")
        print(savedSurveyStart)
        print("-DONE-")
        surveyStart = savedSurveyStart

    }
    
    func sendEmail(toSend: String) {
        
    //sending export data through email: wsl-research@dcs.upd.edu.ph || bpsy@up.edu.ph
    
    // Data consists of: date of birth, blood glucose levels and dates, and sex. HealthKit functionality required.
    // Subject: SugarTraces Health Data
        
      if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.setToRecipients(["bpsy@up.edu.ph"])
        mail.setSubject("SugarTraces Survey Answers")
        
        var messageBody = [String]()
        
        messageBody.append(toSend)
        

        mail.setMessageBody(messageBody.joined(separator:"|"), isHTML: true)

        present(mail, animated: true)
      } else {
        // show failure alert
      }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        
        //this seems to make it true even if the person presses cancel instead of done at the very end
//        taskViewController.dismiss(animated: true, completion: {() in self.consentDone = true})
        taskViewController.dismiss(animated: true, completion: nil)

        switch (reason) {
          case .completed:
            
            //extracting the results from the survey
              let taskResult = taskViewController.result.results
              print(taskResult)
              
//              var ctr = 0
              var flg = false
              
              for stepResults in taskResult! as! [ORKStepResult]{
//                print(ctr)
                  print("---")
                  for result in stepResults.results! {
                    
                    //Check if consent is done. consentDone = true means YES!
                    if result.identifier == "UserSignature"{
                        print(result)
                        let consentDoneAnswerResult = result as! ORKConsentSignatureResult
                        let consentDone = consentDoneAnswerResult.consented
                        surveyStart = consentDone
                        print(consentDone)
                        saveSurveyStart()
                        consentBtn.setTitle("Leave Research", for: .normal)
                        consentBtn.titleLabel?.adjustsFontSizeToFitWidth = true

                        
                        //now locally save the status of consent on the phone that the consent is done
                        
                        
                    }
                    
                    //extracting the answers from the survey itself now using the identifiers
                    
//                    if result.identifier == "NameStep"{
//                        print(result)
//                        let nameAnswerResult = result as! ORKTextQuestionResult
//                        let name = nameAnswerResult.answer!
//                        print(name)
//
//                    }
                    
                    //Dictionary for every single question to prevent any duplicate answers
                    
                    if result.identifier == "Question1Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question1"] = ansString
                    }
                    
                    if result.identifier == "Question2Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question2"] = ansString
                    }
                    if result.identifier == "Question3Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question3"] = ansString
                    }
                    if result.identifier == "Question4Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question4"] = ansString
                    }
                    if result.identifier == "Question5Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question5"] = ansString
                    }
                    if result.identifier == "Question6Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question6"] = ansString
                    }
                    if result.identifier == "Question7Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question7"] = ansString
                    }
                    if result.identifier == "Question8Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question8"] = ansString
                    }
                    if result.identifier == "Question9Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question9"] = ansString
                    }
                    if result.identifier == "Question10Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question10"] = ansString
                    }
                    if result.identifier == "Question11Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question11"] = ansString
                    }
                    if result.identifier == "Question12Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question12"] = ansString
                    }
                    if result.identifier == "Question13Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question13"] = ansString
                    }
                    if result.identifier == "Question14Step"{
                        print(result)
                        let questionAnswerResult = result as! ORKChoiceQuestionResult
                        let answer = questionAnswerResult.answer!
                        var ansString = String(describing: answer)
                        ansString = ansString.filter("12345.".contains)
                        answers["Question14"] = ansString
                        flg = true
                    }
                    
                  }
              }
//              ctr = ctr + 1
              
              //turning into json to send over on AWS/email (depending on implementationa)
              if flg == true {
                flg = false
                let jsonData = try! JSONSerialization.data(withJSONObject: answers)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                print(jsonString!, "\n", type(of: jsonString))
                var str = String(jsonString!)
                sendEmail(toSend: str)
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
        loadSurveyStart()
        print("didLoad", surveyStart)
        if surveyStart == true {
            consentBtn.setTitle("Leave Research", for: .normal)
            consentBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadSurveyStart()
        print("didAppear", surveyStart)
        if surveyStart == true {
            consentBtn.setTitle("Leave Research", for: .normal)
            consentBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
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
            
            // create the alert
            let alert = UIAlertController(title: "Leave Research?", message: "Would you like to leave the research?", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                  switch action.style{
                  case .default:
                    self.surveyStart = false
                    self.saveSurveyStart()
                    self.consentBtn.setTitle("Get Started", for: .normal)
                    self.consentBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                    
                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")

            }}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
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
            let alert = UIAlertController(title: "Consent needed!", message: "We need your consent before you can start!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")

            }}))
            self.present(alert, animated: true, completion: nil)
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
