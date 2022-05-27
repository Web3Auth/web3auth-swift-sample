//
//  web3AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 30/03/22.
//

import CustomAuth
import Foundation
import Web3Auth

class Web3AuthManager: ObservableObject {
    private var clientID: String = "BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc"
    @Published var network: Network {
        didSet {
            auth = Web3Auth(.init(clientId: clientID, network: network))
        }
    }

    var auth: Web3Auth

    init(network: Network) {
        self.network = network
        auth = Web3Auth(.init(clientId: clientID, network: network))
    }

    func getClientID() -> String {
        return clientID
    }

    func login(provider: Web3AuthProvider) async throws -> Web3AuthState {
        return try await withCheckedThrowingContinuation { continuation in
            auth.login(.init(loginProvider: provider.rawValue)) {
                result in
                switch result {
                case let .success(model):
                    continuation.resume(returning: model)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func loginWithEmail(email: String) async throws -> Web3AuthState {
        return try await withCheckedThrowingContinuation { continuation in
            let extraOptions = ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: email, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil)
            auth.login(.init(loginProvider: Web3AuthProvider.EMAIL_PASSWORDLESS.rawValue, extraLoginOptions: extraOptions)) {
                result in
                switch result {
                case let .success(model):
                    continuation.resume(returning: model)
                case let .failure(error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
