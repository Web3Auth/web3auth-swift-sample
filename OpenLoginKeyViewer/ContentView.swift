//
//  ContentView.swift
//  OpenLoginKeyViewer
//
//  Created by Michael Lee on 7/1/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        if authManager.currentUser != nil {
            HomeView(ethManager: EthManager(proxyAddress: "0x1776e71Bb1956c46D9bBA247cd979B1c887dE633", authManager: authManager)!)
        } else {
            LoginHomePageview()
        }
        
    }
}



