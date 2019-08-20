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
    
    func years() -> Int {
        return Calendar.current.dateComponents([.year], from: self.dateValue(), to: Date()).year ?? 0
    }
    func months() -> Int {
        return Calendar.current.dateComponents([.month], from: self.dateValue(), to: Date()).month ?? 0
    }
    func weeks() -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: self.dateValue(), to: Date()).weekOfMonth ?? 0
    }
    func days() -> Int {
        return Calendar.current.dateComponents([.day], from: self.dateValue(), to: Date()).day ?? 0
    }
    func hours() -> Int {
        return Calendar.current.dateComponents([.hour], from: self.dateValue(), to: Date()).hour ?? 0
    }
    func minutes() -> Int {
        return Calendar.current.dateComponents([.minute], from: self.dateValue(), to: Date()).minute ?? 0
    }
    func seconds() -> Int {
        return Calendar.current.dateComponents([.second], from: self.dateValue(), to: Date()).second ?? 0
    }
    func offset() -> String {
        if years()   > 0 { return "\(years())y"   }
        if months()  > 0 { return "\(months())M"  }
        if weeks()   > 0 { return "\(weeks())w"   }
        if days()    > 0 { return "\(days())d"    }
        if hours()   > 0 { return "\(hours())h"   }
        if minutes() > 0 { return "\(minutes())m" }
        if seconds() > 0 { return "Now" }
        return ""
    }
}
