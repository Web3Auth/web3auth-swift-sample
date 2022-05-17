//
//  OpenLoginKeyViewerApp.swift
//  OpenLoginKeyViewer
//
//  Created by Michael Lee on 7/1/2022.
//

import SwiftUI
import CustomAuth

@main
struct OpenLoginSampleApp: App {
    @StateObject var authManager = AuthManager()
    @StateObject var web3AuthManager = Web3AuthManager(network: .mainnet)
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                CustomAuth.handle(url: url)
            }
                .environmentObject(authManager)
                .environmentObject(web3AuthManager)
        }
        
    }
    
}



