//
//  ConvertFirebaseTimeStamp.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/4/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Firebase
import FirebaseFirestore

extension Timestamp {
    func toTime() -> String {
        let sentDate = self.dateValue()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mma"
        let formattedDate = formatter.string(from: sentDate)
        return formattedDate
    }
}
