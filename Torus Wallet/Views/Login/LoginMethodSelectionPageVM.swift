//
//  LoginMethodSelectionPageVM.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import Combine
import Web3Auth

class LoginMethodSelectionPageVM: ObservableObject {
    @Published private var authManager: AuthManager
    @Published var showError: Bool = false
    @Published var errorMessage = ""
    @Published var userEmail: String = ""
    @Published var isRowExpanded: Bool = false
    @Published var network: Network = .mainnet
    @Published var blockchain: BlockchainEnum = .ETHMainnet
    var cancellables: Set<AnyCancellable> = []
    var loginRow1Arr: [Web3AuthProvider] = [.APPLE, .GOOGLE, .FACEBOOK, .TWITTER]
    var loginRow2Arr: [Web3AuthProvider] = [.LINE, .REDDIT, .DISCORD, .WECHAT, .TWITCH]
    var loginRow3Arr: [Web3AuthProvider] = [.GITHUB, .LINKEDIN, .KAKAO]
    var networkArr = Network.allCases

    init(authManager: AuthManager) {
        self.authManager = authManager
        setup()
    }

    func setup() {
        authManager.$showError.sink { val in
            self.showError = val
        }
        .store(in: &cancellables)
        authManager.$errorMessage.sink { val in
            self.errorMessage = val
        }
        .store(in: &cancellables)
        $network.sink(receiveValue: { val in
            self.authManager.network = val
        })
        .store(in: &cancellables)
        $blockchain.sink(receiveValue: { val in
            self.authManager.blockchain = val
        })
        .store(in: &cancellables)
    }

    func login(_ provider: Web3AuthProvider) {
        authManager.login(provider: provider)
    }

    func loginWithEmail() {
        authManager.loginWithEmail(email: userEmail)
    }
}
