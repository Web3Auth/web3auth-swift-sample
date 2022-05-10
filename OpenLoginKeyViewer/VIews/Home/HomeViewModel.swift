//
//  HomeViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 18/04/22.
//

import SwiftUI
import Combine
import web3
import Web3Auth




@MainActor
class HomeViewModel:ObservableObject{
    
    @Published var convertedBalance:Double = 0
    @Published var currentCurrency:TorusSupportedCurrencies = .ETH
    @Published var currentRate:Double = 0
    
    var publicAddress:String{
        return manager.addressString
    }
    
    var manager:BlockChainManagerProtocol
    
    
    init(manager:BlockChainManagerProtocol){
        self.manager = manager
        currentCurrency = manager.type == .ethereum ? .ETH : .SOL
        getBalance()
    }
    
    
    
    func getBalance(){
        Task(priority: .userInitiated){
        do{
            let userBalance = try await manager.getBalance()
            currentRate = await NetworkingClient.shared.getCurrentPrice(blockChain:manager.type,forCurrency: currentCurrency)
            convertedBalance = userBalance * currentRate
        }
        catch{
            print(error)
        }
        }
    }
    
    func getConversionRate(){
        Task(priority: .userInitiated){
        do{
            let userBalance = try await manager.getBalance()
            currentRate = await NetworkingClient.shared.getCurrentPrice(blockChain:manager.type,forCurrency: currentCurrency)
            convertedBalance = userBalance * currentRate

        }
        catch{
            print(error)
        }
        }
    }
    
    func signMessage(message:String) -> String{
           if let signedMessage = manager.signMessage(message: message){
               return signedMessage
           }
           else{
               return ""
           }
   }
}
