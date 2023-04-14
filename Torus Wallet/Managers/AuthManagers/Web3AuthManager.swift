//
//  Web3AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 03/11/22.
//

import Foundation
import Web3Auth

extension Network {
    var clientID: String {
        switch self {
        case .mainnet:
            return "BEaGnq-mY0ZOXk2UT1ivWUe0PZ_iJX4Vyb6MtpOp7RMBu_6ErTrATlfuK3IaFcvHJr27h6L1T4owkBH6srLphIw"
        case .testnet:
            return "BKWc-6_pz5wgoZ5jvmgvbytxt7A8dvTTgsByZ87b8f-7NZW5zdhbznxT2MWJYJEv_O6MClj-g_HS4lYPJ4uQFhk"
        case .cyan:
            return "BA5akJpGy6j5bVNL33RKpe64AXTiPGTSCYOI0i-BbDtbOYWtFQNdLzaC-WKibRtQ0sV_TVHC42TdOTbyZXdN-XI"
        }
    }
}

class Web3AuthManager: ObservableObject {
    private var clientID: String = ""
    private var auth: Web3Auth?
    private var network: Network {
        didSet {
            clientID = network.clientID
        }
    }

    init(network: Network) {
        self.network = network
        self.clientID = network.clientID
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
