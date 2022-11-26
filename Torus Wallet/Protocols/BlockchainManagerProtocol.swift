//
//  BlockchainManagerProtocol.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/05/22.
//

import Combine
import Foundation

protocol BlockchainManagerProtocol {
    var blockchainDidChange: AnyPublisher<Bool, Error> { get }
    var manager: BlockChainProtocol! { get }
    var user: User { get }
    func changeBlockChain(blockchain: BlockchainEnum)
    func logout()
}

class DummyBlockchainManager: BlockchainManagerProtocol {
    var blockchainDidChange = PassthroughSubject<Bool, Error>().eraseToAnyPublisher()

    func changeBlockChain(blockchain: BlockchainEnum) {
    }

    var blockchain: BlockchainEnum = .ETHMainnet

    var manager: BlockChainProtocol! {
        return Dummy()
    }

    var user: User {
        return DummyUser
    }

    func changeNetwork(blockchain: BlockchainEnum) {
    }

    func logout() {
    }
}
