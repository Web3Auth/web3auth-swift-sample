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
        if authManager.currentUser != nil, let manager: BlockChainManagerProtocol = authManager.currentBlockChain == .ethereum ? EthManager(authManager: authManager, network: $web3AuthManager.network) : SolanaManager(authManager: authManager) {
            HomeView(manager: manager)
                .environmentObject(authManager)
                .environmentObject(web3AuthManager)
        } else {
            LoginHomePageview(vm: .init(web3AuthManager: .init(network: .mainnet), authManager: authManager))
        }
    }
}
