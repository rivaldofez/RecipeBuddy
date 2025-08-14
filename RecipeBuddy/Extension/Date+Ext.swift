//
//  Date+Ext.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
