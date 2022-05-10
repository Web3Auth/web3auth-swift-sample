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
@MainActor
class TransferAssetViewModel:ObservableObject{
    var manager:BlockChainManagerProtocol
    @Published var amount:String = ""
    @Published var selectedTransactionFee = 0
    @Published var sendingAddress:String = ""
    @Published var currentUSDRate:Double = 0
    @Published var transactionSuccess:Bool = false
    @Published var balanceError:Bool = false
    @Published var recipientAddressError:Bool = false
    @Published var currentCurrency:TorusSupportedCurrencies
    @Published var loading = false
    var lastTransactionHash:String = ""
    var addressType:[AddressType] = []
    @Published var selectItemToTransfer:BlockchainEnum
    @Published var showEditBtn = false
    
    var currencyInArr:[TorusSupportedCurrencies] = []
    var maxTransactionDataModel:[MaxTransactionDataModel]{
        return manager.maxTransactionDataModel
    }
    
     var selectedMaxTransactionDataModel:MaxTransactionDataModel{
         if  maxTransactionDataModel.count > 0 {
              return maxTransactionDataModel[selectedTransactionFee]
         }
         else{
             return .init(id: 0, title: "Loading", time: 0, amt: 0)
         }
    }
    
    func convertAmountToETH() -> Double{
        guard let amt = Double(amount)  else{return 0}
        let convCurr = amt / (currentCurrency == .ETH || currentCurrency == .SOL ? 1:currentUSDRate)
      return convCurr
    }
   
    
    
    var totalAmountInEth:String{
        let doubleAmt = convertAmountToETH()
         guard doubleAmt != 0 else{return "0"}
         let val = doubleAmt + selectedMaxTransactionDataModel.maxTransAmtInEth
        return "\(String(format: "%.6f", val))"
         }
    
    
    var totalAmountInUSD:String{
        let doubleAmt = convertAmountToETH()
        guard doubleAmt != 0 else{return "0"}
        let ethAmt = doubleAmt + selectedMaxTransactionDataModel.maxTransAmtInEth
        let usdAmt = currentUSDRate * ethAmt
       return "\(String(format: "%.6f", usdAmt))"
   }
    
    func convertAmtToUSD(amount:String) -> Double{
        guard let amt = Double(amount)  else{return 0}
        let convCurr = amt * currentUSDRate
        return convCurr
    }
    
  
    

    
    func checkBalanceError(){
        validate()
        if Double(convertAmountToETH()) > manager.userBalance{
            balanceError = true
            HapticGenerator.shared.generateHaptic(val: .error)
        }
        else{
            
        }
    }
    
    

    
    func checkRecipentAddressError(){
        if manager.checkRecipentAddressError(address: sendingAddress){
            recipientAddressError = false
            }
            else{
            recipientAddressError = true
            }
    }
    
    
    
  
    
    init(manager:BlockChainManagerProtocol){
        self.manager = manager
        currencyInArr.append(manager.type == .ethereum ? .ETH : .SOL)
        currencyInArr.append(.USD)
        currentCurrency = currencyInArr[0]
        addressType.append(AddressType(rawValue: manager.type.rawValue) ?? .ethAddress)
   
        selectItemToTransfer = manager.type
        Task{
            await manager.getMaxtransAPIModel()
            let val  = await NetworkingClient.shared.getCurrentPrice(blockChain: manager.type,forCurrency: .USD)
            DispatchQueue.main.async { [weak self] in
                self?.currentUSDRate = val
            }
        }
    }
    
    func validate(){
        if amount.numberOfOccurrencesOf(string: ".") > 1{
            amount.removeLast()
        }
    }

    func transferAsset() async throws{
        let ethAmount = TorusUtil.toWei(ether: convertAmountToETH())
            do{
                loading.toggle()
                let val = try await manager.transferAsset(sendTo: sendingAddress, amount:ethAmount, maxTip: BigUInt(TorusUtil.toEther(Gwie: BigUInt(selectedMaxTransactionDataModel.amt))), gasLimit: 21000)
                transactionSuccess.toggle()
                lastTransactionHash = val
            }
            catch{
                print(error)
                loading.toggle()

                throw error
            }
        loading.toggle()
    }
}


