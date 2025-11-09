//
//  UPIParser.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import Foundation

// MARK: - UPI Parser

/// Converts UPI deeplinks to payment app specific deeplinks
enum UPIURIParser {
    /// Validates and converts a UPI URL to a payment app deeplink
    /// - Parameters:
    ///   - urlString: The UPI URL string (format: upi://pay?pa=xxx@xxx&...)
    ///   - appScheme: The URL scheme of the target payment app
    /// - Returns: A deeplink string for the payment app, or nil if invalid
    static func constructDeepLink(from urlString: String, appScheme: String) -> String? {
        // Validate it's a UPI URL
        guard urlString.lowercased().hasPrefix("upi://") else {
            return nil
        }

        // Extract everything after "upi://"
        let afterScheme = String(urlString.dropFirst(6)) // "upi://" is 6 characters

        // Ensure there's actually content after the scheme
        guard !afterScheme.isEmpty else {
            return nil
        }

        // Different apps use different path structures
        switch appScheme {
        case "gpay", "paytmmp":
            return "\(appScheme)://upi/\(afterScheme)"
        default:
            return "\(appScheme)://\(afterScheme)"
        }
    }
}
