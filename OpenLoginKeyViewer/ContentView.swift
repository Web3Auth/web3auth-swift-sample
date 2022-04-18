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
        if authManager.currentUser != nil, let ethManager = EthManager(authManager: authManager){
            HomeView( vm: .init(ethManager: ethManager))
                .environmentObject(ethManager)
            }
        else {
            LoginHomePageview()
        }
        
    }
}



