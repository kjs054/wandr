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
    func getInitials() -> String
    {
        let initials = self.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first ?? " ")" }.uppercased()
        return initials
    }
}
