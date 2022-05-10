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
    
    
    func checkRecipentAddressError(address: String) -> Bool {
        return true
    }
    
    
    
    
    func getMaxtransAPIModel() async {
        print("err")
    }
    
 var maxTransactionDataModel: [MaxTransactionDataModel] = []
    
   @Published var userBalance: Double = 0
    
    func transferAsset(sendTo: String, amount: BigUInt, maxTip: BigUInt = 0, gasLimit: BigUInt = 0) async throws -> String {
        return try await withCheckedThrowingContinuation({(continuation : CheckedContinuation<String, Error>) in
            solana.action.sendSOL(to: sendTo, amount: UInt64(amount)){ result in
                    switch result{
                    case .success(let val):
                        continuation.resume(returning: val)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
            }
        })
    }
    
    var type: BlockchainEnum = .solana
    
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
          //  getGasfee()
        case .failure(_):
            return nil
        }
        
    }
    
    
    func signMessage(message:String) -> String?{
        return ""
   }
    
    
    func getGasfee(){
        solana.api.getFeeRateGovernor { result in
            switch result{
            case .success(let fee):
                print(fee)
                
            case .failure(let error):
                print(error)
            }
        }
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
}


