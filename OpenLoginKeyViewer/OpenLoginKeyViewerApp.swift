//
//  OpenLoginKeyViewerApp.swift
//  OpenLoginKeyViewer
//
//  Created by Michael Lee on 7/1/2022.
//

import SwiftUI

@main
struct OpenLoginKeyViewerApp: App {
    @StateObject var authManager = AuthManager()
    @StateObject var web3AuthManager = Web3AuthManager(network: .mainnet)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(web3AuthManager)
        }
        
    }
    
}



