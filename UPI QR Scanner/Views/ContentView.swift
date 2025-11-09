//
//  ContentView.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties

    @StateObject private var settingsManager = SettingsManager.shared
    @State private var scannedCode: String?
    @State private var showSettings = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    @State private var lastScannedTime: Date?

    private let scanCooldownDuration: TimeInterval = 3

    // MARK: - Body

    var body: some View {
        ZStack {
            QRScannerView(scannedCode: $scannedCode)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()

                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding()
                }

                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)

                    Text("Point at UPI QR Code")
                        .font(.headline)
                        .foregroundStyle(.white)

                    if let selectedApp = settingsManager.selectedApp {
                        HStack(spacing: 8) {
                            AppIconView(app: selectedApp, size: 24)
                            Text("Using \(selectedApp.name)")
                                .foregroundStyle(.white)
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                    } else {
                        Button {
                            showSettings = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Select Payment App")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.red, in: Capsule())
                        }
                    }
                }
                .padding(.bottom, 100)
            }

            if showSuccess {
                VStack {
                    Spacer()

                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Opening payment app...")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(.ultraThickMaterial, in: Capsule())
                    .padding(.bottom, 50)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .onChange(of: scannedCode) { _, newValue in
            if let code = newValue {
                handleScannedCode(code)
            }
        }
        .onAppear {
            let installedApps = PaymentAppsManager.shared.getInstalledApps()
            AppIconFetcher.shared.preloadIcons(for: installedApps)
        }
    }

    // MARK: - Private Methods

    private func handleScannedCode(_ code: String) {
        guard shouldProcessScan() else { return }

        lastScannedTime = Date()

        guard let selectedApp = settingsManager.selectedApp else {
            showErrorAlert("Please select a payment app in settings")
            showSettings = true
            return
        }

        guard let deepLink = UPIURIParser.constructDeepLink(from: code, appScheme: selectedApp.scheme) else {
            showErrorAlert("Not a valid UPI QR code")
            return
        }

        openPaymentApp(deepLink: deepLink, app: selectedApp)

        resetScannerAfterDelay()
    }

    private func shouldProcessScan() -> Bool {
        guard let lastTime = lastScannedTime else { return true }
        return Date().timeIntervalSince(lastTime) >= scanCooldownDuration
    }

    private func openPaymentApp(deepLink: String, app: PaymentApp) {
        guard let url = URL(string: deepLink) else {
            showErrorAlert("Failed to create payment link")
            return
        }

        guard UIApplication.shared.canOpenURL(url) else {
            showErrorAlert("\(app.name) is not installed or cannot handle this payment")
            return
        }

        withAnimation {
            showSuccess = true
        }

        UIApplication.shared.open(url) { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.showSuccess = false
                }
            }

            if !success {
                self.showErrorAlert("Failed to open \(app.name)")
            }
        }
    }

    private func showErrorAlert(_ message: String) {
        errorMessage = message
        showError = true
    }

    private func resetScannerAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + scanCooldownDuration) {
            scannedCode = nil
        }
    }
}

#Preview {
    ContentView()
}
