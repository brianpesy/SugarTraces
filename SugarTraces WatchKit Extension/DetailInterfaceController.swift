//
//  DetailInterfaceController.swift
//  SugarTraces WatchKit Extension
//
//  Created by Brian Sy on 19/10/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var imgAch: WKInterfaceImage!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let detailData = context as? Bool {
//            detailLabel.setText(detailData as! String)
            
            //we can start doing our operations in here. We passed if the achievement is 1 or 0 (1: true, 0: false). We can base the deatil off this value.
            
            print(detailData)
            
            if detailData == false {
//                imgAch.setImage("lock")
                print("in")
                imgAch.setImage(UIImage(named: "lock"))
            } else {
                print("hi")
            }
            
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
