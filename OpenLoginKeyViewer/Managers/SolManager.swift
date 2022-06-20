import BigInt
import KeychainSwift
import Solana
import UIKit
import web3

class SolanaManager: BlockChainManagerProtocol, ObservableObject {
    var userBalancePublished: Published<Double>.Publisher { $userBalance }
    var lastestBlockHash: String = ""
    var lamportsPerSOL: Double = 1000000000
    var type: BlockchainEnum = .solana
    var showTransactionFeeOption: Bool = false
    @Published var maxTransactionDataModel: [MaxTransactionDataModel] = []
    @Published var userBalance: Double = 0
    private let solana: Solana
    var authManager: AuthManager
    private let endpoint: RPCEndpoint = .mainnetBetaSolana
    private let network: NetworkingRouter
    var account: Account
    var addressString: String {
        return account.publicKey.base58EncodedString
    }

    func getMaxtransAPIModel() async {
        solana.api.getFees { [weak self] result in
            switch result {
            case let .success(fee):
                let fees = Double(fee.feeCalculator?.lamportsPerSignature ?? 0) / (self?.lamportsPerSOL ?? 1)
                self?.maxTransactionDataModel = [.init(id: 0, title: "Fast", time: 0.5, amt: Double(fees))]
            case let .failure(error):
                print(error)
            }
        }
    }

    func getMaxtransactionFee(amount: Double) -> Double {
        return amount
    }

    init?(authManager: AuthManager) {
        self.authManager = authManager
        network = NetworkingRouter(endpoint: .mainnetBetaSolana)
        solana = Solana(
            router: network
        )
        let result = authManager.account
        switch result {
        case let .success(account):
            self.account = account
        case .failure:
            return nil
        }
    }

    func checkRecipentAddressError(address: String) -> Bool {
        guard let pubKey = PublicKey(string: address),pubKey.bytes.count >= 32 else{return false}
        return PublicKey.isOnCurve(publicKeyBytes: pubKey.data).toBool()
        
    }

    func getBlock() async -> Bool {
        return await withCheckedContinuation({ continuation in
            solana.api.getRecentBlockhash { [weak self] result in
                switch result {
                case let .success(val):
                    if self?.lastestBlockHash != val {
                        self?.lastestBlockHash = val
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                case .failure:
                    continuation.resume(returning: true)
                }
            }
        })
    }

    func signMessage(message: String) async -> String {
        let transaction = TransactionInstruction(keys: [.init(publicKey: account.publicKey, isSigner: true, isWritable: true)], programId: account.publicKey, data: message.data(using: .utf8)!.bytes)
        return await withCheckedContinuation({ (continuation: CheckedContinuation<String, Never>) in
            solana.action.serializeTransaction(instructions: [transaction], signers: [account]) { result in
                switch result {
                case let .success(result):
                    continuation.resume(returning: result)
                case .failure:
                    continuation.resume(returning: "")
                }
            }
        })
    }

    func getBalance() {
        Task {
            let blockChanged = await getBlock()
            guard blockChanged == true else { userBalance = userBalance
                return
            }
            solana.api.getBalance(account: account.publicKey.base58EncodedString) { [weak self] result in
                switch result {
                case let .success(val):
                    let curr = Double(val) / pow(10, 9)
                    self?.userBalance = curr
                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    func transferAsset(sendTo: String, amount: Double, maxTip: Double = 0, gasLimit: BigUInt = 0) async throws -> String {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String, Error>) in
            let amountInLamport = amount * lamportsPerSOL
            solana.action.sendSOL(to: sendTo, from: account, amount: UInt64(amountInLamport)) { result in
                switch result {
                case let .success(val):
                    continuation.resume(returning: val)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            } })
    }
}


