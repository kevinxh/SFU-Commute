//
//  string.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-04.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
