//
//  File.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import Foundation
import BigInt
import web3

struct TransactionModel {
    var amount: BigUInt
    var maxTransactionFee: BigUInt
    var totalCost: BigUInt
    var senderAddress: EthereumAddress
    var reciepientAddress: EthereumAddress
    var network: EthereumNetwork
}

struct MaxTransactionDataModel: Hashable, Identifiable {
    var id: Int
    var title: String
    var time: Double
    var amt: Double
    var timeInSec: Double {
        TorusWeb3Utils.timeMinToSec(val: time)
    }
}

struct ETHGasAPIResponseModel: Codable {
    let fast, fastest, safeLow, average: Double
    let speed, safeLowWait: Double
    let avgWait: Double
    let fastWait, fastestWait: Double

}
