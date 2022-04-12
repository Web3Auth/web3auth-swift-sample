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
          //  LoginHomePageview()
            HomeView(ethManager: EthManager(authManager: authManager))
        } else {
            LoginHomePageview()
        }
        
    }
}



