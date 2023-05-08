import BigInt
import Combine
import Foundation
import Solana

class SolanaManager: BlockChainProtocol, ObservableObject {
    private var userBalanceSub: PassthroughSubject<Double, Never>
    private let solana: Solana
    private let endpoint: RPCEndpoint
    private let network: NetworkingRouter
    private var lastestBlockHash: String = ""
    private var lamportsPerSOL: Double = 1000000000
    private var account: Account
    unowned var blockchainManager: BlockchainManager
    var userBalancePublished: AnyPublisher<Double, Never>
    var addressString: String {
        return account.publicKey.base58EncodedString
    }

    @Published var maxTransactionDataModel: [MaxTransactionDataModel] = []
    var type: BlockchainEnum
    var showTransactionFeeOption: Bool = false

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

    required init?(blockchainManager: BlockchainManager, endpoint: RPCEndpoint, type: BlockchainEnum) {
        self.blockchainManager = blockchainManager
        self.type = type
        self.endpoint = endpoint
        network = NetworkingRouter(endpoint: endpoint)
        solana = Solana(
            router: network
        )
        let result = blockchainManager.account
        switch result {
        case let .success(account):
            self.account = account
        case .failure:
            return nil
        }
        userBalanceSub = .init()
        userBalancePublished = userBalanceSub.eraseToAnyPublisher()
    }

    func checkRecipentAddressError(address: String) -> Bool {
        guard let pubKey = PublicKey(string: address), pubKey.bytes.count >= 32 else { return false }
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
            guard blockChanged == true else {
                return
            }
            solana.api.getBalance(account: account.publicKey.base58EncodedString) { [weak self] result in
                switch result {
                case let .success(val):
                    let balance = Double(val) / pow(10, 9)
                    self?.userBalanceSub.send(balance)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    func transferAsset(sendTo: String, amount: Double, maxTip: Double = 0, gasLimit: BigUInt = 0) async throws -> String {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String, Error>) in
            let amountInLamport = amount * lamportsPerSOL
            solana.action.sendSOL(to: sendTo, from: account, amount: UInt64(amountInLamport), allowUnfundedRecipient: true) { result in
                switch result {
                case let .success(val):
                    continuation.resume(returning: val)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            } })
    }

    func logout() {
        blockchainManager.logout()
    }
}
