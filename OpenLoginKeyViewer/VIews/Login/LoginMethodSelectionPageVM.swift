//
//  LoginMethodSelectionPageVM.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import Combine
import SwiftUI
import Web3Auth

@MainActor
class LoginMethodSelectionPageVM: ObservableObject {
    @Published var web3AuthManager: Web3AuthManager
    @Published var authManager: AuthManager
    @Published var showError = false
    @Published var showSuccess = false
    @Published var errorMessage = ""
    @Published var userEmail: String = ""
    @Published var selectedBlockchain: BlockchainEnum = .ethereum
    @Published var userInfo: Web3AuthState? {
        didSet {
            saveUser()
        }
    }

    init(web3AuthManager: Web3AuthManager, authManager: AuthManager) {
        self.web3AuthManager = web3AuthManager
        self.authManager = authManager
    }

    func saveUser() {
        guard let safeuser = userInfo else { return }
        if selectedBlockchain == .ethereum {
            authManager.currentBlockChain = .ethereum
        } else if selectedBlockchain == .solana {
            authManager.currentBlockChain = .solana
        }

        authManager.saveUser(user: .init(privKey: safeuser.privKey, ed25519PrivKey: safeuser.ed25519PrivKey, userInfo: .init(name: safeuser.userInfo.name, profileImage: safeuser.userInfo.profileImage, typeOfLogin: safeuser.userInfo.typeOfLogin, aggregateVerifier: safeuser.userInfo.aggregateVerifier, verifier: safeuser.userInfo.verifier, verifierId: safeuser.userInfo.verifierId, email: safeuser.userInfo.email), currentBlockchain: authManager.currentBlockChain))
    }

    func login(_ provider: Web3AuthProvider?) {
        Task {
            guard let provider = provider else { return }
            do {
                userInfo = try await web3AuthManager.login(provider: provider)
            } catch {
                print(error)
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }

    func loginWithEmail() {
        Task {
            if userEmail.invalidEmail() {
                errorMessage = "Invalid Email"
                showError.toggle()
            } else {
                do {
                    userInfo = try await web3AuthManager.loginWithEmail(email: userEmail)
                } catch {
                    print(error)
                    errorMessage = error.localizedDescription
                    showError.toggle()
                }
            }
        }
    }
}
