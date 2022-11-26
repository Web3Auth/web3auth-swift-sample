//
//  BlockchainManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 04/11/22.
//

import Foundation
import Combine
import web3
import Solana

class BlockchainManager: BlockchainManagerProtocol, ObservableObject {
    var blockchainDidChange: AnyPublisher<Bool, Error>
    private var authManager: AuthManager
    var blockchain: BlockchainEnum
    var manager: BlockChainProtocol!
    private var sub: PassthroughSubject<Bool, Error>
    var user: User
    var type: BlockchainEnum {
        return blockchain
    }
    var cancellables: Set<AnyCancellable> = []
    init?(authManager: AuthManager, user: User) {
        self.user = user
        self.authManager = authManager
        blockchain = authManager.blockchain
        sub = PassthroughSubject<Bool, Error>()
        blockchainDidChange = sub.share().eraseToAnyPublisher()
        if let manager = blockchain.createBlockChainManagerFactory(blockManager: self) {
            self.manager = manager
            saveUserSetting()
        } else {
            return nil
        }
    }
}

extension BlockchainManager {
    func changeBlockChain(blockchain: BlockchainEnum) {
        self.blockchain = blockchain
        if let manager = blockchain.createBlockChainManagerFactory(blockManager: self) {
            self.manager = manager
            saveUserSetting()
            sub.send(true)
        }
    }

    func logout() {
        authManager.logout()
    }

    func saveUserSetting() {
            let configData: ConfigDataStruct = .init(blockchain: blockchain, network: authManager.network, isLoggedIn: true)
            if let data = try? JSONEncoder().encode(configData) {
                UserDefaultsManager.shared.save(key: .configData, val: data)
            }
    }
}

extension BlockchainManager: EthereumKeyStorageProtocol {
    func storePrivateKey(key: Data) throws {
    }

    func loadPrivateKey() throws -> Data {
        guard let user = authManager.user, let userData = user.privKey.web3.hexData else { throw NetworkingError.customErr("Invalid Key") }
        return userData
    }
}

extension BlockchainManager: SolanaAccountStorage {
    func save(_ account: Account) -> Swift.Result<Void, Error> {
        return .success(())
    }

    var account: Swift.Result<Account, Error> {
        if let user = authManager.user, let account = Account(secretKey: user.ed25519PrivKey.web3.hexData ?? Data()) {
            return .success(account)
        } else {
            return .failure(SolanaError.unauthorized)
        }
    }

    func clear() -> Swift.Result<Void, Error> {
        return .success(())
    }
}
