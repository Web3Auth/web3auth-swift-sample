//
//  HomeViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 18/04/22.
//

import Combine
import SwiftUI
import web3
import Web3Auth

@MainActor
class HomeViewModel: ObservableObject {
    @Published var convertedBalance: Double = 0
    @Published var currentCurrency: TorusSupportedCurrencies
    @Published var currentRate: Double = 0
    var userBalance: Double = 0
    var cancellables: Set<AnyCancellable> = []
    var convRateCache = [BlockchainEnum: [TorusSupportedCurrencies: Double]]()
    var publicAddress: String {
        return manager.addressString
    }

    var timer: Timer?
    var manager: BlockChainManagerProtocol

    init(manager: BlockChainManagerProtocol) {
        self.manager = manager
        currentCurrency = manager.type.currencyValue
        configTimers()
        configPublishers()
        manager.getBalance()
    }

    func getConversionRate() {
        Task(priority: .userInitiated) {
            if let cached = convRateCache[manager.type]?[currentCurrency] {
                currentRate = cached
            } else {
                currentRate = await NetworkingClient.shared.getCurrentPrice(blockChain: manager.type, forCurrency: currentCurrency)
                addConvRateInCache(currentRate: currentRate)
            }
               convertedBalance = userBalance * currentRate
            }
        }
    
    func addConvRateInCache(currentRate:Double){
        if let _ = convRateCache[manager.type] {
            convRateCache[manager.type]?[currentCurrency] = currentRate
        } else {
            convRateCache[manager.type] = [currentCurrency: currentRate]
        }
    }

    func signMessage(message: String) async -> String {
        return await manager.signMessage(message: message)
    }
}

// cleanUP

extension HomeViewModel {
    func cleanup() {
        clearCache()
        cancellables.forEach { val in
            val.cancel()
        }
        timer?.invalidate()
    }
}

// Publishers
extension HomeViewModel {
    func configPublishers() {
        manager.userBalancePublished.receive(on: RunLoop.main)
            .sink { [weak self] val in
                self?.userBalance = val
                self?.getConversionRate()
            }
            .store(in: &cancellables)
    }
}

// Timers
extension HomeViewModel {
    func configTimers() {
        timer = .scheduledTimer(timeInterval: UpdationTimeConstants.convRateUpdation, target: self, selector: #selector(clearCache), userInfo: nil, repeats: true)
        timer = .scheduledTimer(timeInterval: UpdationTimeConstants.balanceUpdation, target: self, selector: #selector(updateBalance), userInfo: nil, repeats: true)
    }

    @objc func updateBalance()  {
        manager.getBalance()
    }

    @objc func clearCache() {
        convRateCache.removeAll()
        getConversionRate()
    }
}

