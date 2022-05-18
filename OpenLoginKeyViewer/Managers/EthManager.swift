//
//  EthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 07/04/22.
//

import BigInt
import Combine
import Foundation
import SwiftUI
import web3
import Web3Auth

class EthManager: BlockChainManagerProtocol {
    var userBalancePublished: Published<Double>.Publisher { $userBalance }

    func getMaxtransactionFee(amount: Double) -> Double {
        return TorusUtil.toEther(Gwie: BigUInt(amount) * 21000)
    }

    var blockNum: Int = 0
    var type: BlockchainEnum = .ethereum

    var showTransactionFeeOption: Bool = true

    func checkRecipentAddressError(address: String) -> Bool {
        return address.isValidEthAddress()
    }

    var addressString: String {
        return address.value
    }

    @Published var userBalance: Double = 0
    var authManager: AuthManager
    var client: EthereumClientProtocol
    var address: EthereumAddress
    @Binding var network: Network
    var projectID: String = "7f287687b3d049e2bea7b64869ee30a3"
    var urlSession: URLSession
    var account: EthereumAccount
    var networkName: String {
        return "Ethereum \(network.name)"
    }

    var latestBlock = 0
    var timer: Timer?
    @Published var maxTransactionDataModel: [MaxTransactionDataModel] = []

    init?(urlSession: URLSession = URLSession.shared, authManager: AuthManager, network: Binding<Network>) {
        do {
            _network = network
            self.authManager = authManager
            self.urlSession = urlSession
            let clientUrl = URL(string: "https://ropsten.infura.io/v3/\(projectID)")!
            client = EthereumClient(url: clientUrl, sessionConfig: urlSession.configuration)
            account = try EthereumAccount(keyStorage: authManager)
            address = account.address
        } catch {
            print(error)
            return nil
        }
    }

    deinit {
        timer?.invalidate()
    }

    func checkLatestBlockChanged() async -> Bool {
        return await withCheckedContinuation({ continuation in
            client.eth_blockNumber { [weak self] _, val in
                guard let val = val, self?.latestBlock != val else {
                    continuation.resume(returning: false)
                    return
                }
                self?.latestBlock = val
                continuation.resume(returning: true)
            }
        })
    }

    func getMaxtransAPIModel() async {
        do {
            let val = try await NetworkingClient.shared.getSuggestedGasFees()
            DispatchQueue.main.async { [weak self] in
                self?.maxTransactionDataModel = val
            }
        } catch {
            print(error)
        }
    }

    func getBalance() {
        Task {
            let blockChanged = await checkLatestBlockChanged()
            guard blockChanged == true else { return }
            client.eth_getBalance(address: self.address, block: .Latest) { [unowned self] error, balance in
                if let error = error {
                    print(error)
                }
                if let balance = balance {
                    let newBalance = TorusUtil.toEther(wei: Wei(balance))
                    userBalance = newBalance
                }
            }
        }
    }

    func signMessage(message: String) async -> String {
        do {
            let val = try account.sign(message: message)
            return val.web3.hexString
        } catch {
            return ""
        }
    }

    func transferAsset(sendTo: String, amount: Double, maxTip: Double, gasLimit: BigUInt = 21000) async throws -> String {
        let gasPrice = try await client.eth_gasPrice()
        let maxTipInGwie = BigUInt(TorusUtil.toEther(Gwie: BigUInt(amount)))
        let totalGas = gasPrice + maxTipInGwie
        let amtInGwie = TorusUtil.toWei(ether: amount)
        let nonce = try await client.eth_getTransactionCount(address: address, block: .Latest)
        let transaction = EthereumTransaction(from: address, to: EthereumAddress(sendTo), value: amtInGwie, data: Data(), nonce: nonce + 1, gasPrice: totalGas, gasLimit: gasLimit, chainId: 3)
        let signed = try account.sign(transaction: transaction)
        let val = try await client.eth_sendRawTransaction(signed.transaction, withAccount: account)
        return val
    }
}
