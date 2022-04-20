//
//  ContentView.swift
//  OpenLoginKeyViewer
//
//  Created by Michael Lee on 7/1/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var web3AuthManager: Web3AuthManager
    var body: some View {
        if authManager.currentUser != nil, let ethManager = EthManager(authManager: authManager, network: $web3AuthManager.network){
            HomeView( vm: .init(ethManager: ethManager))
                .environmentObject(ethManager)
            }
        else {
            LoginHomePageview()
        }
        
    }
}



