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
                .preferredColorScheme(settingsManager.colorScheme)
                .environmentObject(settingsManager)
        }
    }
}

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
      navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}
