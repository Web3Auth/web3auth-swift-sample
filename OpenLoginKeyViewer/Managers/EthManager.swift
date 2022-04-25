//
//  EthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 07/04/22.
//

import Foundation
import SwiftUI
import Combine
import web3
import BigInt
import Web3Auth

class EthManager:ObservableObject{
    var userbalance:Double = 0
    var authManager:AuthManager
    var client: EthereumClientProtocol
    var address : EthereumAddress
   @Binding var network:Network
    var projectID:String = "7f287687b3d049e2bea7b64869ee30a3"
    var urlSession : URLSession
    var updated = false
    var account:EthereumAccount
    
    var networkName:String{
        return "Ethereum \(network.name)"
    }
    
    init?(urlSession:URLSession = URLSession.shared,authManager:AuthManager,network:Binding<Network>){
        do{
            self._network = network
        self.authManager = authManager
        self.urlSession = urlSession
            let clientUrl = URL(string: "https://ropsten.infura.io/v3/\(projectID)")!
            client = EthereumClient(url: clientUrl, sessionConfig: urlSession.configuration)
            account = try EthereumAccount.init(keyStorage: authManager)
            address = account.address
        }
        catch{
       print(error)
           return nil
        }
    }
    
    func getBalance() async throws -> Double{
        try await withCheckedThrowingContinuation{ continuation in
            client.eth_getBalance(address: self.address, block: .Latest) {[unowned self] error, balance in
                if let error = error{
                    continuation.resume(throwing: error)
                }
                if let balance = balance {
                    let newBalance = TorusUtil.toEther(wei: Wei(balance))
                   userbalance = newBalance
                        continuation.resume(returning: newBalance)
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

    func transferAsset(sendTo:EthereumAddress,amount:BigUInt,maxTip:BigUInt,gasLimit:BigUInt = 21000) async throws -> String {
        let gasPrice = try await client.eth_gasPrice()
        let totalGas = gasPrice + maxTip
        let nonce = try await client.eth_getTransactionCount(address: address, block: .Latest)
        let transaction = EthereumTransaction(from: address, to: sendTo, value: amount, data: Data(), nonce: nonce + 1, gasPrice: totalGas, gasLimit: gasLimit,chainId: 3)        
        let signed = try account.sign(transaction: transaction)
        let val = try await client.eth_sendRawTransaction(signed.transaction, withAccount: self.account)
        return val
    }
}
