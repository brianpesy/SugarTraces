//
//  AddReadingController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 15/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit
import AVFoundation

extension NSString {
    var isInt: Bool {
        return Int(self as String) != nil
    }
}

class AddReadingController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var readingTextField: WKInterfaceTextField!
    
    var audioPlayer: AVAudioPlayer!
    
    let defaults = UserDefaults.standard

    var loggedReadings: [Int] = []
    var loggedDates: [String] = []
    var wcSession: WCSession!
    
    var transferToPhone: [String: [Any]] = [:]
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
    }
    
    func loadLoggedData(){
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
    func saveLoggedData(){
        defaults.set(loggedReadings, forKey: Keys.savedReadings)
        defaults.set(loggedDates, forKey: Keys.savedDates)
    }
    
    
    @IBAction func textField(_ value: NSString?) {
        //whatever value is typed here will be saved to the loggedReading and date, sent over to the main app as well.
        //sound effect after inputting
        if value != nil && value != ""{
            if value!.isInt {
                //load whatever is in
                loadLoggedData()
                
                print(value!)
                var num = Int(value! as String)!
                //sound effect
                let dingPath = Bundle.main.path(forResource: "DING.mp3", ofType: nil)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingPath!))
                } catch {
                    print(error)
                }
                audioPlayer.play()
                
                //add to 0th index of the arrays
                
                //Put data in array
                let date = Date()
                let formatter = DateFormatter()
                //Date formatting
                formatter.timeZone = .current
                formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
                
                loggedReadings.insert(num, at: 0)
                loggedDates.insert(formatter.string(from:date), at:0)
                
                print("inside watch")
                print(loggedReadings)
                print(loggedDates)
                
                saveLoggedData()
                
                //send over data to the iPhone app
                
                if WCSession.isSupported() {
                    self.wcSession = WCSession.default
                    self.wcSession.delegate = self
                    self.wcSession.activate()
                }
                
                transferToPhone = ["readings": loggedReadings, "dates": loggedDates]
                //when I send a message over with the Text Field, I can send it to the WC Session.
                
//                wcSession.sendMessage(transferToPhone, replyHandler: nil, errorHandler: error in print(error.localizedDescription))
//                    replyHandler()
//                wcSession.sendMessage(transferToPhone, replyHandler: {(_ replyMessage: [String: Any]) -> Void in
//
//                    print("ReplyHandler called = \(replyMessage)")
//                },
//                errorHandler: {(_ error: Error) -> Void in
//
//                    print("Error = \(error.localizedDescription)")
//                })
                if wcSession.isReachable {
                    wcSession.sendMessage(transferToPhone, replyHandler: {reply in print("done")}, errorHandler: {error in
                        
                        do {
                            try self.wcSession.updateApplicationContext(self.transferToPhone)

                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    
                    print("sent data over to phone")
                }
                print("bam")
            }
        }
    }
    
    
}
