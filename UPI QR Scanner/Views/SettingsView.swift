//
//  SettingsView.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @StateObject private var settingsManager = SettingsManager.shared
    @State private var installedApps: [PaymentApp] = []

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    if installedApps.isEmpty {
                        ContentUnavailableView(
                            "No Payment Apps Found",
                            systemImage: "app.dashed",
                            description: Text("Install a UPI payment app to get started")
                        )
                    } else {
                        ForEach(installedApps) { app in
                            Button {
                                settingsManager.selectedApp = app
                            } label: {
                                HStack(spacing: 12) {
                                    AppIconView(app: app, size: 44)

                                    Text(app.name)
                                        .foregroundStyle(.primary)
                                        .font(.body)

                                    Spacer()

                                    if settingsManager.selectedApp?.id == app.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.blue)
                                            .font(.title3)
                                    }
                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Installed Apps")
                } footer: {
                    if !installedApps.isEmpty {
                        Text("Select your preferred UPI payment app. This app will be used when you scan a QR code.")
                    }
                }

                Section {
                    Toggle(isOn: $settingsManager.hapticFeedbackEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "iphone.radiowaves.left.and.right")
                                .foregroundStyle(.blue)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Haptic Feedback")
                                Text("Vibrate when QR code is scanned")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Scanning Options")
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("How it works", systemImage: "info.circle")
                            .font(.headline)

                        Text("1. Point your camera at a UPI QR code")
                        Text("2. The app will automatically detect and scan it")
                        Text("3. Your selected payment app will open with the payment details")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            installedApps = PaymentAppsManager.shared.getInstalledApps()
            AppIconFetcher.shared.preloadIcons(for: installedApps)
        }
    }
}

#Preview {
    SettingsView()
}
