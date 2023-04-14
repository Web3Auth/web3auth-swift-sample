//
//  Torus_WalletApp.swift
//  Torus Wallet
//
//  Created by Dhruv Jaiswal on 19/11/22.
//

import SwiftUI

@main
struct Torus_WalletApp: App {
    @StateObject var settingsManager: SettingsManager = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, settingsManager.colorScheme)
                .environment(\.locale, Locale(identifier: "gr"))
                .environmentObject(settingsManager)
        }
    }
}
