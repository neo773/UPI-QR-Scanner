//
//  PaymentAppsManager.swift
//  UPI QR Scanner
//
//  Created by neo on 09/11/25.
//

import Foundation

// MARK: - Payment Apps Manager

/// Manages the list of available UPI payment applications
final class PaymentAppsManager {
    static let shared = PaymentAppsManager()

    private init() {}

    /// All supported UPI payment applications
    let availableApps: [PaymentApp] = [
        PaymentApp(id: "gpay", name: "Google Pay", scheme: "gpay", iconName: "g.circle.fill", bundleId: "com.google.paisa"),
        PaymentApp(id: "phonepe", name: "PhonePe", scheme: "phonepe", iconName: "p.circle.fill", bundleId: "com.phonepe.PhonePeApp"),
        PaymentApp(id: "paytm", name: "Paytm", scheme: "paytmmp", iconName: "p.square.fill", bundleId: "net.one97.paytm"),
        PaymentApp(id: "bhim", name: "BHIM", scheme: "upi", iconName: "b.circle.fill", bundleId: "in.org.npci.ios.upiapp"),
        PaymentApp(id: "whatsapp", name: "WhatsApp Pay", scheme: "whatsapp", iconName: "message.circle.fill", bundleId: "net.whatsapp.WhatsApp"),
        PaymentApp(id: "amazonpay", name: "Amazon Pay", scheme: "amazonpay", iconName: "a.circle.fill", bundleId: "com.amazon.mobile.shopping"),
        PaymentApp(id: "cred", name: "CRED", scheme: "credpay", iconName: "c.circle.fill", bundleId: "com.dreamplug.CRED"),
        PaymentApp(id: "mobikwik", name: "MobiKwik", scheme: "mobikwik", iconName: "m.circle.fill", bundleId: "com.mobikwik"),
        PaymentApp(id: "payzapp", name: "PayZapp", scheme: "payzapp", iconName: "h.circle.fill", bundleId: "com.hdfcbank.payzapp"),
        PaymentApp(id: "paytmpb", name: "Paytm Bank", scheme: "paytmpb", iconName: "p.circle", bundleId: "com.paytmbank.ppbl"),
        PaymentApp(id: "kotak811", name: "Kotak 811", scheme: "kotak811", iconName: "k.circle.fill", bundleId: "com.kotak811mobilebankingapp.instantsavingsupiscanandpayrecharge")
    ]

    /// Returns only the apps that are installed on the device
    func getInstalledApps() -> [PaymentApp] {
        availableApps.filter { $0.isInstalled }
    }
}
