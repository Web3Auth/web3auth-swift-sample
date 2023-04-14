//
//  ContentView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 19/11/22.
//

import SwiftUI

struct ContentView: View {

    @StateObject var authManager: AuthManager = .init()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: POPPINSFONTLIST.Bold.name, size: 24)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: POPPINSFONTLIST.SemiBold.name, size: 16)!]
    }

    var body: some View {
        if authManager.loading {
            LoadingView()
                .ignoresSafeArea()
        } else {
            if let user = authManager.user, let blockchainManager = BlockchainManager(authManager: authManager, user: user) {
                TabView {
                    HomeView(vm: .init(blockchainManager: blockchainManager))
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    SettingView(vm: .init(blockchainManager: blockchainManager))
                        .tabItem {
                            Label("Setting", systemImage: "gear")
                        }
                }
                .accentColor(Color.tabBarColor())
            } else {
                LoginHomePageview(vm: .init(authManager: authManager))
            }
        }
    }
}
