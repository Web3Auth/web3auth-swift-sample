import UIKit
import Solana
import KeychainSwift
import BigInt
import BigInt

enum SolanaError: Error {
    case accountFailed
    case unauthorized
}
 
class SolanaManager:BlockChainManagerProtocol {
    func getMaxtransactionFee(amount: Double) -> Double {
        return amount
    }
    
    
    var type: BlockchainEnum = .solana
    
    var showTransactionFeeOption: Bool = false
    
    
    
    func checkRecipentAddressError(address: String) -> Bool {
        return false
    }
    
    
    
    
    func getMaxtransAPIModel() async {
        solana.api.getFees{[weak self] result in
            switch result{
            case .success(let fee):
                let fees = Double(fee.feeCalculator?.lamportsPerSignature ?? 0) / 1000000000
                self?.maxTransactionDataModel = [.init(id: 0, title: "Fast", time: 30, amt: Double(fees))]
            case .failure(let error):
                print(error)
            }
        }
    }
    
 @Published var maxTransactionDataModel: [MaxTransactionDataModel] = []
    
   @Published var userBalance: Double = 0
    
    var addressString: String{
        return account.publicKey.base58EncodedString
    }

    private let solana: Solana
    var authManager:AuthManager
    private let endpoint: RPCEndpoint = .devnetSolana
    private let network: NetworkingRouter
    var account:Account

    init?(authManager:AuthManager) {
        self.authManager = authManager
        self.network = NetworkingRouter(endpoint: .devnetSolana)
        self.solana = Solana(
            router: network,
            accountStorage: authManager
        )
        let result = solana.auth.account
        switch result{
        case .success(let account):
            self.account = account
        case .failure(_):
            return nil
        }
        
    }
    
    
    func signMessage(message:String) -> String?{
        return ""
   }
    
    
    
    
    func getBalance() async throws -> Double {
        return try await withCheckedThrowingContinuation({(continuation : CheckedContinuation<Double, Error>) in
                solana.api.getBalance(account: account.publicKey.base58EncodedString){[weak self] result in
                    switch result{
                    case .success(let val):
                        let curr = Double(val) / pow(10, 9)
                        self?.userBalance = curr
                        continuation.resume(returning: curr)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
            }
        })
    }
    
    
    func transferAsset(sendTo: String, amount: Double, maxTip: Double = 0, gasLimit: BigUInt = 0) async throws -> String {
        return try await withCheckedThrowingContinuation({(continuation : CheckedContinuation<String, Error>) in
            let amountInLamport = amount * 1000000000
            solana.action.sendSOL(to: sendTo, amount: UInt64(amountInLamport)){ result in
                    switch result{
                    case .success(let val):
                        continuation.resume(returning: val)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
            }
        })
    }
}


