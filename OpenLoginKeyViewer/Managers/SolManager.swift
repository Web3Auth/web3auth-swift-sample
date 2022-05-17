import BigInt
import KeychainSwift
@testable import Solana
import UIKit

enum SolanaError: Error {
    case accountFailed
    case unauthorized
}

class SolanaManager: BlockChainManagerProtocol {
    func getMaxtransactionFee(amount: Double) -> Double {
        return amount
    }

    var lamportsPerSOL: Double = 1000000000

    var type: BlockchainEnum = .solana

    var showTransactionFeeOption: Bool = false

    func checkRecipentAddressError(address: String) -> Bool {
        return address.count >= PublicKey.LENGTH ? true : false
    }

    func getMaxtransAPIModel() async {
        solana.api.getFees { [weak self] result in
            switch result {
            case let .success(fee):
                let fees = Double(fee.feeCalculator?.lamportsPerSignature ?? 0) / (self?.lamportsPerSOL ?? 1)
                self?.maxTransactionDataModel = [.init(id: 0, title: "Fast", time: 30, amt: Double(fees))]
            case let .failure(error):
                print(error)
            }
        }
    }

    @Published var maxTransactionDataModel: [MaxTransactionDataModel] = []

    @Published var userBalance: Double = 0

    var addressString: String {
        return account.publicKey.base58EncodedString
    }

    private let solana: Solana
    var authManager: AuthManager
    private let endpoint: RPCEndpoint = .devnetSolana
    private let network: NetworkingRouter
    var account: Account

    init?(authManager: AuthManager) {
        self.authManager = authManager
        network = NetworkingRouter(endpoint: .devnetSolana)
        solana = Solana(
            router: network,
            accountStorage: authManager
        )
        let result = solana.auth.account
        switch result {
        case let .success(account):
            self.account = account
        case .failure:
            return nil
        }
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

    func getBalance() async throws -> Double {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Double, Error>) in
            solana.api.getBalance(account: account.publicKey.base58EncodedString) { [weak self] result in
                switch result {
                case let .success(val):
                    let curr = Double(val) / pow(10, 9)
                    self?.userBalance = curr
                    continuation.resume(returning: curr)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    func transferAsset(sendTo: String, amount: Double, maxTip: Double = 0, gasLimit: BigUInt = 0) async throws -> String {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<String, Error>) in
            let amountInLamport = amount * lamportsPerSOL
            solana.action.sendSOL(to: sendTo, amount: UInt64(amountInLamport)) { result in
                switch result {
                case let .success(val):
                    continuation.resume(returning: val)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}

extension TransactionInstruction {
}
