//
//  StringExtension.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

extension String
{
    func getInitials() -> String {
        let initials = self.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first ?? " ")" }.uppercased()
        return initials
    }
    
    func formatPhone() -> String? { //Needed to convert phone book values to firebase format
        let numbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        // Leading 1
        let leadingOne = hasLeadingOne ? "+" : "+1"
        
        return leadingOne + numbersOnly
    }
}
