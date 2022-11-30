//
//  EthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 07/04/22.
//
import BigInt
import Combine
import Foundation
import web3

class EthManager: BlockChainProtocol {
    var user: User {
        return blockchainManager.user
    }
    private var sub: PassthroughSubject<Double, Never>
    private var chainID: Int
    private var blockNum: Int = 0
    unowned var blockchainManager: BlockchainManager
    private var client: EthereumClientProtocol
    private var address: EthereumAddress
    private var projectID: String = "7f287687b3d049e2bea7b64869ee30a3"
    private var account: EthereumAccount
    private var latestBlock = 0
    var type: BlockchainEnum
    var userBalancePublished: AnyPublisher<Double, Never>
    var showTransactionFeeOption: Bool = true
    var addressString: String {
        return address.value
    }
    @Published var maxTransactionDataModel: [MaxTransactionDataModel] = []

    init?(blockchainManager: BlockchainManager, clientURL: URL, type: BlockchainEnum, chainID: Int) {
        do {
            self.blockchainManager = blockchainManager
            let clientUrl = clientURL
            self.type = type
            self.chainID = chainID
            client = EthereumClient(url: clientUrl)
            account = try EthereumAccount(keyStorage: blockchainManager)
            address = account.address
            sub = .init()
            userBalancePublished = sub.share().eraseToAnyPublisher()
        } catch {
            print(error)
            return nil
        }
    }

    func logout() {
        blockchainManager.logout()
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

    func getMaxtransactionFee(amount: Double) -> Double {
        return TorusWeb3Utils.toEther(Gwie: BigUInt(amount) * 21000)
    }

    func checkRecipentAddressError(address: String) -> Bool {
        return address.isValidEthAddress()
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
            guard blockChanged == true else {
                return
            }
            client.eth_getBalance(address: self.address, block: .Latest) { [unowned self] error, val in
                if let error = error {
                    print(error)
                }
                if let val = val {
                    let balance = TorusWeb3Utils.toEther(wei: Wei(val))
                    sub.send(balance)
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
        let maxTipInGwie = BigUInt(TorusWeb3Utils.toEther(Gwie: BigUInt(amount)))
        let totalGas = gasPrice + maxTipInGwie
        let amtInGwie = TorusWeb3Utils.toWei(ether: amount)
        let nonce = try await client.eth_getTransactionCount(address: address, block: .Latest)
        let transaction = EthereumTransaction(from: address, to: EthereumAddress(sendTo), value: amtInGwie, data: Data(), nonce: nonce + 1, gasPrice: totalGas, gasLimit: gasLimit, chainId: chainID)
        let signed = try account.sign(transaction: transaction)
        let val = try await client.eth_sendRawTransaction(signed.transaction, withAccount: account)
        return val
    }
}
