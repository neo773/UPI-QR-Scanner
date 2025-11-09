//
//  PaymentApp.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import Foundation
import UIKit

/// Represents a UPI payment application
struct PaymentApp: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let scheme: String
    let iconName: String
    let bundleId: String

    /// Checks if the app is installed on the device
    var isInstalled: Bool {
        guard let url = URL(string: "\(scheme)://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// iTunes API URL for fetching the app icon
    var iconURL: String {
        "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=in"
    }
}
