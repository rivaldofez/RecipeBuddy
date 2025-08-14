//
//  String+Ext.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
    
    func quantityToDouble() -> Double? {
        let quantity = self
        let trimmed = quantity.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.contains("/") {
            let parts = trimmed.split(separator: "/").map { String($0) }
            if parts.count == 2,
               let numerator = Double(parts[0]),
               let denominator = Double(parts[1]),
               denominator != 0 {
                return numerator / denominator
            }
            return nil
        }

        return Double(trimmed)
    }
}
