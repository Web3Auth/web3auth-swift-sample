//
//  BlockchainManagerProtocol.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/05/22.
//

import Foundation
import SwiftUI
import Combine
import web3
import BigInt
import Web3Auth



protocol BlockChainManagerProtocol{
    
    func getMaxtransactionFee(amount:Double) -> Double
    var authManager:AuthManager{get}
    var type:BlockchainEnum { get }
    var maxTransactionDataModel:[MaxTransactionDataModel] { get }
    var userBalance:Double{get}
    var showTransactionFeeOption:Bool {get}
    var addressString:String {get}
    func getBalance() async throws -> Double
    func signMessage(message:String) -> String?
    func transferAsset(sendTo:String,amount:Double,maxTip:Double,gasLimit:BigUInt) async throws -> String
    func getMaxtransAPIModel() async
    func checkRecipentAddressError(address:String) -> Bool
    
}
