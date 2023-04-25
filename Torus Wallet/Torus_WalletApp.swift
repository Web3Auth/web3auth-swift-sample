//
//  Torus_WalletApp.swift
//  Torus Wallet
//
//  Created by Dhruv Jaiswal on 19/11/22.
//

import SwiftUI

@main
struct Torus_WalletApp: App {
    @UIApplicationDelegateAdaptor
    private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
      navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}
