//
//  UILabelExtension.swift
//  SugarTraces
//
//  Created by Brian Sy on 30/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}
