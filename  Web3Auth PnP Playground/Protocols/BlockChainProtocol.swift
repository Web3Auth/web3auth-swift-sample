//
//  BlockChainProtocol.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 12/11/22.
//

import Foundation
import BigInt
import Combine

protocol BlockChainProtocol: AnyObject {
    var blockchainManager: BlockchainManager {get}
    var type: BlockchainEnum { get }
    var maxTransactionDataModel: [MaxTransactionDataModel] { get }
    var userBalancePublished: AnyPublisher<Double, Never> {get}
    var showTransactionFeeOption: Bool {get}
    var addressString: String {get}
    func getBalance()
    func signMessage(message: String) async -> String
    func getMaxtransactionFee(amount: Double) -> Double
    func transferAsset(sendTo: String, amount: Double, maxTip: Double, gasLimit: BigUInt) async throws -> String
    func getMaxtransAPIModel() async
    func checkRecipentAddressError(address: String) -> Bool
    func logout()
}

class Dummy: BlockChainProtocol {
    var userBalancePublished = PassthroughSubject<Double, Never>().eraseToAnyPublisher()

    var user: User {
        return DummyUser
    }

    func logout() {
    }

    var blockchainManager: BlockchainManager {
        return .init(authManager: .init(), user: DummyUser)!
    }

    @Published var userBalance: Double = 0

    var type: BlockchainEnum {
        return .ETHMainnet
    }

    var maxTransactionDataModel: [MaxTransactionDataModel] {
        return []
    }

    var showTransactionFeeOption: Bool {
        return false
    }

    var addressString: String {
        return "9xdjfnjbjbdjbd"
    }

    func getBalance() {
    }

    func signMessage(message: String) async -> String {
        return message
    }

    func getMaxtransactionFee(amount: Double) -> Double {
        return 0
    }

    func transferAsset(sendTo: String, amount: Double, maxTip: Double, gasLimit: BigUInt) async throws -> String {
        return "0xnxjdebdbjfbdbjd"
    }

    func getMaxtransAPIModel() async {

    }

    func checkRecipentAddressError(address: String) -> Bool {
        return true
    }

}
