//
//  ContentView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 19/11/22.
//

import SwiftUI

struct ContentView: View {

    @StateObject var authManager: AuthManager = .init()
    @StateObject var tabVM = TabViewModel()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: POPPINSFONTLIST.Bold.name, size: 24)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: POPPINSFONTLIST.SemiBold.name, size: 16)!]
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
    }

    var body: some View {
        if authManager.loading {
            LoadingView()
                .ignoresSafeArea()
        } else {
            if let user = authManager.user, let blockchainManager = BlockchainManager(authManager: authManager, user: user) {
                TabView(selection: $tabVM.selectedTab) {
                    HomeView(vm: .init(blockchainManager: blockchainManager))
                        .environmentObject(tabVM)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    SettingView(vm: .init(blockchainManager: blockchainManager))
                        .environmentObject(tabVM)
                        .tabItem {
                            Label("Setting", systemImage: "gear")
                        }
                        .tag(1)
                }
                .accentColor(Color.tabBarColor())
            } else {
                LoginHomePageview(vm: .init(authManager: authManager))
            }
        }
    }
}

class TabViewModel: ObservableObject {
    @Published var selectedTab = 0

    init() {}
}
