//
//  EthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 07/04/22.
//

import Foundation
import Combine
import web3
import BigInt
import Web3Auth

class EthManager:ObservableObject{
    
    var authManager:AuthManager
    var client: EthereumClientProtocol
    var proxyAddress : EthereumAddress
    var network:EthereumNetwork = .Mainnet
    var projectID:String = "7f287687b3d049e2bea7b64869ee30a3"
    var urlSession : URLSession
    var updated = false
    let keyStorage = EthereumKeyLocalStorage()
    var account:EthereumAccount
    
    
    init?(proxyAddress:String,urlSession:URLSession = URLSession.shared,authManager:AuthManager){
        do{
        self.authManager = authManager
        self.urlSession = urlSession
        self.proxyAddress = EthereumAddress(proxyAddress)
        let clientUrl = URL(string: "https://ropsten.infura.io/v3/\(projectID)")!
        client = EthereumClient(url: clientUrl, sessionConfig: urlSession.configuration)
        account = try EthereumAccount.create(keyStorage: keyStorage, keystorePassword: authManager.currentUser?.privKey ?? "")
        }
        catch{
          return nil
        }
    }
    
    func getBalance() async throws -> Double{
        try await withCheckedThrowingContinuation{ continuation in
            client.eth_getBalance(address: self.proxyAddress, block: .Latest) { error, balance in
                if let error = error{
                    continuation.resume(throwing: error)
                }
                if let balance = balance {
                    do{
                    let newBalance = try Converter.toEther(wei: Wei(balance))
                        continuation.resume(returning: newBalance)
                    }
                    catch{
                        continuation.resume(throwing: error)
                    }
                    
                }
            }
        }
    }
    
    func signMessage(message:String) -> String?{
        do{
       let val = try account.sign(message: message)
            return val.web3.hexString
        }
        catch{
            return nil
        }

    }
    
    
//    func transferAsset(sendTo:EthereumAddress,amount:BigUInt,gasLimit:BigUInt) async throws -> String {
//        guard let account = account else {
//            throw OpenLoginError.AccountError
//        }
//        let function = EthereumNetwork.Rinkeby
//        let transaction = try function.transaction()
//        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
//        return txHash
//    }
    
    
   
}




