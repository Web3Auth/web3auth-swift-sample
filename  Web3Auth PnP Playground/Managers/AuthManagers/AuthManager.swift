//
//  AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 02/11/22.
//

import Foundation
import Web3Auth

class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var loading: Bool = false
    private var web3AuthManager: Web3AuthManager?
    var blockchain: BlockchainEnum = .ETHMainnet
    var network: Network = .mainnet

    init() {
        loading = true
        initialLoad()
    }

    func initialLoad() {
        switch loadDataFromKeychain() {
        case let .success(data):
            self.network = data.network
            self.blockchain = data.blockchain
            setupWeb3Auth(val: data)
        case let .failure:
            loading = false
        }
    }

    func setupWeb3Auth(val: ConfigDataStruct) {
        Task {
            web3AuthManager = Web3AuthManager(network: val.network)
            await web3AuthManager?.setup()
            await MainActor.run(body: {
                if let web3AuthState = web3AuthManager?.getUser() {
                    let user = self.web3AuthStateToUser(web3AuthState)
                    setUser(user: user)
                }
                loading = false
            })

        }
    }

    func web3AuthStateToUser(_ web3AuthState: Web3AuthState) -> User {
        return .init(privKey: web3AuthState.privKey!,
                     ed25519PrivKey: web3AuthState.ed25519PrivKey!,
                     userInfo: .init(name: web3AuthState.userInfo?.name ?? "",
                                     profileImage: web3AuthState.userInfo!.profileImage ?? "",
                                     typeOfLogin: web3AuthState.userInfo!.typeOfLogin ?? "",
                                     aggregateVerifier: web3AuthState.userInfo?.aggregateVerifier ?? "",
                                     verifier: web3AuthState.userInfo?.verifier ?? "",
                                     verifierId: web3AuthState.userInfo?.verifierId,
                                     email: web3AuthState.userInfo?.email ?? ""))
    }
}

extension AuthManager {

    @MainActor func setUser(user: User) {
        self.user = user
        // saveUser()
    }

    // if user is not logged in
    func initWeb3Auth() async {
        web3AuthManager = .init(network: network)
        await web3AuthManager?.setup()
    }

    func login(provider: Web3AuthProvider) {
        Task {
            await initWeb3Auth()
            do {
                let web3AuthState = try await web3AuthManager?.login(provider: provider)
                // fix
                let user = self.web3AuthStateToUser(web3AuthState!)
                await setUser(user: user)
            } catch let err {
                await MainActor.run(body: {
                    errorMessage = err.localizedDescription
                    showError = true
                })

            }
        }
    }

    func loginWithEmail(email: String) {
        Task {
            await initWeb3Auth()
            if email.invalidEmail() {
                await MainActor.run(body: {
                    errorMessage = "Invalid Email"
                    showError = true
                })
            } else {
                do {
                    let web3AuthState = try await web3AuthManager?.loginWithEmail(email: email)
                    // fix
                    let user = self.web3AuthStateToUser(web3AuthState!)
                    await setUser(user: user)
                } catch let err {
                    await MainActor.run(body: {
                        errorMessage = err.localizedDescription
                        showError = true
                    })
                }
            }
        }
    }

    func logout() {
        Task {
            do {
                try await web3AuthManager?.logout()
                UserDefaultsManager.shared.delete(key: .configData)
                await MainActor.run {
                    user = nil
                }
            } catch let err {
                errorMessage = err.localizedDescription
                showError = true
            }
        }
    }
}

extension AuthManager {

    func loadDataFromKeychain() -> Result<ConfigDataStruct> {
        if let data = UserDefaultsManager.shared.get(key: .configData), let decodedData = try? JSONDecoder().decode(ConfigDataStruct.self, from: data) {
            return .success(decodedData)
        }
        return .failure(Web3AuthError.runtimeError("User not found"))
    }
}
