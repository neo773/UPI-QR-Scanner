//
//  SettingsManager.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import Foundation

// MARK: - Settings Manager

/// Manages user preferences for the selected payment app
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    @Published var selectedApp: PaymentApp? {
        didSet {
            saveSelectedApp()
        }
    }

    @Published var hapticFeedbackEnabled: Bool {
        didSet {
            saveHapticFeedback()
        }
    }

    private let selectedAppKey = "selectedPaymentApp"
    private let hapticFeedbackKey = "hapticFeedbackEnabled"

    private init() {
        hapticFeedbackEnabled = UserDefaults.standard.object(forKey: hapticFeedbackKey) as? Bool ?? true
        loadSelectedApp()
    }

    // MARK: - Private Methods

    private func saveSelectedApp() {
        if let app = selectedApp,
           let encoded = try? JSONEncoder().encode(app) {
            UserDefaults.standard.set(encoded, forKey: selectedAppKey)
        } else {
            UserDefaults.standard.removeObject(forKey: selectedAppKey)
        }
    }

    private func loadSelectedApp() {
        guard let data = UserDefaults.standard.data(forKey: selectedAppKey),
              let app = try? JSONDecoder().decode(PaymentApp.self, from: data) else {
            return
        }
        selectedApp = app
    }

    private func saveHapticFeedback() {
        UserDefaults.standard.set(hapticFeedbackEnabled, forKey: hapticFeedbackKey)
    }
}
