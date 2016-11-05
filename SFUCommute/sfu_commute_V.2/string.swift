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
    
    func isNotEmpty() -> Bool {
        let length = self.characters.count
        return length > 0
    }
    
    func isName() -> Bool {
        if (self.characters.count == 0) {
            return false
        }
        let letters = NSCharacterSet.letters
        return self.rangeOfCharacter(from: letters.inverted) == nil
    }
}
