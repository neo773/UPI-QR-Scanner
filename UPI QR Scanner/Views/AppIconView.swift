//
//  AppIconView.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import SwiftUI

/// Displays an app icon, fetching it from iTunes or showing a fallback
struct AppIconView: View {
    // MARK: - Properties

    let app: PaymentApp
    let size: CGFloat

    @StateObject private var iconFetcher = AppIconFetcher.shared

    // MARK: - Body

    var body: some View {
        Group {
            if let iconURLString = iconFetcher.iconCache[app.bundleId],
               let iconURL = URL(string: iconURLString) {
                AsyncImage(url: iconURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: size, height: size)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size, height: size)
                            .clipShape(RoundedRectangle(cornerRadius: size * 0.225))
                    case .failure:
                        fallbackIcon
                    @unknown default:
                        fallbackIcon
                    }
                }
            } else {
                fallbackIcon
            }
        }
        .onAppear {
            iconFetcher.fetchIcon(for: app.bundleId)
        }
    }

    private var fallbackIcon: some View {
        Image(systemName: app.iconName)
            .font(.system(size: size * 0.5))
            .foregroundStyle(.blue)
            .frame(width: size, height: size)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: size * 0.225))
    }
}

// MARK: - Preview

#Preview {
    AppIconView(
        app: PaymentApp(
            id: "gpay",
            name: "Google Pay",
            scheme: "gpay",
            iconName: "g.circle.fill",
            bundleId: "com.google.paisa"
        ),
        size: 60
    )
}
