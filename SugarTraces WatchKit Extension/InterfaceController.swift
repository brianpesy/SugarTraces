//
//  InterfaceController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 05/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    @IBOutlet weak var lastReadingLabel: WKInterfaceLabel!
    var wcSession: WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.wcSession = WCSession.default
        self.wcSession.delegate = self
        self.wcSession.activate()
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //I can do something after I send a message from the iPhone here
        lastReadingLabel.setText(message["message"] as? String)
        
        //if i want to send something over, it's just
        //the same command for watch to iOS as well!
//        wcSession.sendMessage(message, replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
