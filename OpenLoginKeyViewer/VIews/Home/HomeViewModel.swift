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
    
    @Published var balance:Double = 0
    @Published var currentCurrency:TorusSupportedCurrencies = .ETH
    @Published var currentRate:Double = 0
    var ethManager:EthManager
    
    
    init(ethManager:EthManager){
        self.ethManager = ethManager
        getBalance()
    }
    
    func getBalance(){
        
        Task(priority: .userInitiated){
        do{
            let userBalance = try await ethManager.getBalance()
            currentRate = await NetworkingClient.shared.getCurrentPrice(forCurrency: currentCurrency)
            balance = userBalance * currentRate

        }
        catch{
            print(error)
        }
        }
    }
    
    func getConversionRate(){
        Task(priority: .userInitiated){
        do{
            let userBalance = try await ethManager.getBalance()
            currentRate = await NetworkingClient.shared.getCurrentPrice(forCurrency: currentCurrency)
            balance = userBalance * currentRate

        }
        catch{
            print(error)
        }
        }
    }
    
    func signMessage(message:String) -> String{
           if let signedMessage = ethManager.signMessage(message: message){
               return signedMessage
           }
           else{
               return ""
           }
   }
}
