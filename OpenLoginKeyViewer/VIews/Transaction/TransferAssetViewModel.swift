//
//  TransferAssetViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 18/04/22.
//

import Combine
import UIKit
import SwiftUI
import web3
import BigInt

class TransferAssetViewModel:ObservableObject{
    var ethManager:EthManager
    @Published var maxTransactionDataModel = [MaxTransactionDataModel]()
    @Published var amount:String = ""
    @Published var selectedTransactionFee = 1
    @Published var sendingAddress:String = ""
    @Published var currentUSDRate:Double = 0
    @Published var transactionSuccess:Bool = false
    var totalAmountInEth:String{
         guard let doubleAmt = Double(amount),doubleAmt != 0 else{return "0"}
         let val = doubleAmt + selectedMaxTransactionDataModel.maxTransAmtInEth
        return "\(String(format: "%.6f", val))"
         }
    
    var totalAmountInUSD:String{
        guard let doubleAmt = Double(amount),doubleAmt != 0 else{return "0"}
        let ethAmt = doubleAmt + selectedMaxTransactionDataModel.maxTransAmtInEth
        let usdAmt = currentUSDRate * ethAmt
       return "\(String(format: "%.6f", usdAmt))"
   }
    
     var selectedMaxTransactionDataModel:MaxTransactionDataModel{
          if maxTransactionDataModel.count > 0 {
              return maxTransactionDataModel[selectedTransactionFee]
         }
         else{
             return .init(id: 0, title: "Loading", time: 0, amt: 0)
         }
    }

    

    
    init(ethManager:EthManager){
        self.ethManager = ethManager
        Task{
            await getMaxtransAPIModel()
            
            let val  = await NetworkingClient.shared.getCurrentPrice(forCurrency: .USD)
            DispatchQueue.main.async { [unowned self] in
                currentUSDRate = val
            }
        }
    }
    
    func getMaxtransAPIModel() async{
            do{
                let val = try await NetworkingClient.shared.getSuggestedGasFees()
                DispatchQueue.main.async { [unowned self] in
                    maxTransactionDataModel = val
                }
            }catch{
              print(error)
            }
    }
    
    
    
    func transferAsset() async throws{
        let sendTo = EthereumAddress(sendingAddress)
            do{
                let val = try await ethManager.transferAsset(sendTo: sendTo, amount:TorusUtil.toWei(ether: amount), maxTip: BigUInt(TorusUtil.toEther(Gwie: BigUInt(selectedMaxTransactionDataModel.amt))))
                transactionSuccess.toggle()
                print(val)
            }
            catch{
                print(error)
                throw error
            }
        
    }

    
    
}

