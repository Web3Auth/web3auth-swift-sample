//
//  Web3AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 03/11/22.
//

import Foundation
import Web3Auth

class Web3AuthManager: ObservableObject {
    private var clientID: String = "BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc"
    private var auth: Web3Auth?
    private var network: Network

    init(network: Network) {
        self.network = network
    }

    func setup() async {
        auth = await Web3Auth(.init(clientId: clientID, network: network))
    }

    func getUser() -> Web3AuthState? {
        return auth?.state
    }

    func getClientID() -> String {
        return clientID
    }

    func changeNetwork(network: Network) {
        self.network = network
    }

    func login(provider: Web3AuthProvider) async throws -> Web3AuthState {
        guard let auth = auth else { throw Web3AuthError.runtimeError("Web3Auth not initialised") }
        do {
            return try await auth.login(.init(loginProvider: provider.rawValue))
        } catch let err {
            throw err
        }
    }

    func loginWithEmail(email: String) async throws -> Web3AuthState {
        guard let auth = auth else { throw Web3AuthError.runtimeError("Web3Auth not initialised") }
        let extraOptions = ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: email, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil)
        do {
            return try await auth.login(.init(loginProvider: Web3AuthProvider.EMAIL_PASSWORDLESS.rawValue, extraLoginOptions: extraOptions))
        } catch let err {
            throw err
        }
    }

    func logout() async throws {
        try await auth?.logout()
    }
}
