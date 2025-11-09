//
//  AppIconFetcher.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import Foundation
import SwiftUI

// MARK: - iTunes API Models

struct iTunesAppResponse: Codable {
    let results: [iTunesApp]
}

struct iTunesApp: Codable {
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artworkUrl60: String?
}

// MARK: - App Icon Fetcher

/// Fetches and caches app icons from the iTunes API
@MainActor
final class AppIconFetcher: ObservableObject {
    static let shared = AppIconFetcher()

    @Published var iconCache: [String: String] = [:]
    private var fetchTasks: [String: Task<Void, Never>] = [:]

    private init() {}

    // MARK: - Public Methods

    /// Fetches the app icon from iTunes API
    /// - Parameter bundleId: The bundle identifier of the app
    func fetchIcon(for bundleId: String) {
        guard iconCache[bundleId] == nil, fetchTasks[bundleId] == nil else {
            return
        }

        let task = Task {
            guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=in") else {
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(iTunesAppResponse.self, from: data)

                if let iconURL = response.results.first?.artworkUrl512 ?? response.results.first?.artworkUrl100 {
                    await MainActor.run {
                        self.iconCache[bundleId] = iconURL
                    }
                }
            } catch {
                // Silently fail - fallback icon will be used
            }

            await MainActor.run {
                self.fetchTasks[bundleId] = nil
            }
        }

        fetchTasks[bundleId] = task
    }

    /// Preloads icons for multiple apps
    /// - Parameter apps: Array of payment apps to fetch icons for
    func preloadIcons(for apps: [PaymentApp]) {
        apps.forEach { fetchIcon(for: $0.bundleId) }
    }
}
