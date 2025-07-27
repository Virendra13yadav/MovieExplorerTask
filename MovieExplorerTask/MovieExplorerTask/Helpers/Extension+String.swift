//
//  Extension+String.swift
//  MovieExplorerTask
//
//  Created by Apple on 25/07/25.
//

import Foundation

extension String {
    func toFormattedDate(inputFormat: String = "yyyy-MM-dd", outputFormat: String = "dd MMM yyyy") -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        return self  // return original if parsing fails
    }
    
    func formatDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent month names

        if let date = isoFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
