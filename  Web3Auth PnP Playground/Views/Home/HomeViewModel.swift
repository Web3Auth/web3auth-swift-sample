//
//  HomeViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 18/04/22.
//
import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var convertedBalance: Double = 0
    @Published var currentCurrency: TorusSupportedCurrencies = .USD
    @Published var currentRate: Double = 0
    var signedMessageHashString: String = ""
    var blockchain: BlockchainEnum {
        manager.type
    }
    var user: User {
        return blockchainManager.user
    }

    var getManager: BlockChainProtocol {
        return manager
    }
    var publicAddress: String {
        return manager.addressString
    }
    private var updateBalanceCancellables: AnyCancellable?
    private var userBalance: Double = 0
    private var cancellables: Set<AnyCancellable> = []
    private var convRateCache = [BlockchainEnum: [TorusSupportedCurrencies: Double]]()
    private var blockchainManager: BlockchainManagerProtocol
    var manager: BlockChainProtocol

    init(blockchainManager: BlockchainManagerProtocol) {
        self.blockchainManager = blockchainManager
        manager = blockchainManager.manager
        setup()
        configTimers()
        blockchainManager.blockchainDidChange.sink { _ in
        } receiveValue: { [unowned self] val in
            if val {
                self.manager = blockchainManager.manager
                setup()
            }

        }
        .store(in: &cancellables)
    }

    private func setup() {
        currentCurrency = manager.type.currencyValue
        configPublishers()
        manager.getBalance()
    }

    func changeCurrency(val: TorusSupportedCurrencies) {
        currentCurrency = val
        getConversionRate()
    }

    private func getConversionRate() {
        Task {
                if let cached = convRateCache[manager.type]?[currentCurrency] {
                    await MainActor.run(body: {
                        currentRate = cached
                    })
                } else {
                    let rate = await NetworkingClient.shared.getCurrentPrice(blockChain: manager.type, forCurrency: currentCurrency)
                    addConvRateInCache(currentRate: rate)
                    await MainActor.run(body: {
                        currentRate = rate
                    })
                }
                await MainActor.run(body: {
                    if currentCurrency == manager.type.currencyValue {
                        convertedBalance = userBalance
                    } else {
                        convertedBalance = userBalance * currentRate
                    }
                })
            }
        }

   private func addConvRateInCache(currentRate: Double) {
        if let _ = convRateCache[manager.type] {
            convRateCache[manager.type]?[currentCurrency] = currentRate
        } else {
            convRateCache[manager.type] = [currentCurrency: currentRate]
        }
    }

    func signMessage(message: String) async -> String {
        let msg =  await manager.signMessage(message: message)
        signedMessageHashString = msg
        return msg
    }

    func logout() {
        manager.logout()
    }
}

// cleanUP
extension HomeViewModel {
  private  func cleanup() {
        clearCache()
//        managerCancellables.forEach { val in
//            val.cancel()
//        }
    }
}

// Publishers
extension HomeViewModel {
   private func configPublishers() {
        updateBalanceCancellables?.cancel()
        updateBalanceCancellables = manager.userBalancePublished
            .sink { [weak self] val in
                self?.userBalance = val
                self?.getConversionRate()
            }
    }
}

// Timers
extension HomeViewModel {
   private func configTimers() {
        Timer.publish(every: UpdationTimeConstants.balanceUpdation, on: .main, in: .default).autoconnect()
            .sink { [unowned self] _ in
                updateBalance()
            }.store(in: &cancellables)
        Timer.publish(every: UpdationTimeConstants.convRateUpdation, on: .main, in: .default)
            .sink { [unowned self] _ in
                clearCache()
            }.store(in: &cancellables)

    }

    private func updateBalance() {
        manager.getBalance()
    }

    private func clearCache() {
        convRateCache.removeAll()
        getConversionRate()
    }
}
