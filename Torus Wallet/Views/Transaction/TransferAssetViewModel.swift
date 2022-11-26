//
//  TransferAssetViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 18/04/22.
//

import BigInt
import Combine
import Foundation
import web3

@MainActor
class TransferAssetViewModel: ObservableObject {
    var manager: BlockChainProtocol
    @Published var amount: String = ""
    @Published var selectedTransactionFee = 0
    @Published var sendingAddress: String = ""
    @Published var currentUSDRate: Double = 0
    @Published var transactionSuccess: Bool = false
    @Published var balanceError: Bool = false
    @Published var recipientAddressError: Bool = false
    @Published var currentCurrency: TorusSupportedCurrencies
    @Published var loading = false
    var lastTransactionHash: String = ""
    @Published var selectItemToTransfer: BlockchainEnum
    @Published var showEditBtn = false
    @Published var enableDisableSendBtn: Bool = false
    var userBalance: Double = 0
    var cancellables: Set<AnyCancellable> = []
    var currencyInArr: [TorusSupportedCurrencies] = []
    var maxTransactionDataModel: [MaxTransactionDataModel] {
        return manager.maxTransactionDataModel
    }

    var selectedMaxTransactionDataModel: MaxTransactionDataModel {
        if maxTransactionDataModel.count > 0 {
            return maxTransactionDataModel[selectedTransactionFee]
        } else {
            return .init(id: 0, title: "Loading", time: 0, amt: 0)
        }
    }

    func convertAmountToNative() -> Double {
        guard let amt = Double(amount) else { return 0 }
        let convCurr = amt / (currentCurrency == .USD ? currentUSDRate : 1)
        return convCurr
    }

    deinit {
        print("Free")
        cancellables.forEach { val in
            val.cancel()
        }
    }

     func cleanUp() {
        cancellables.forEach { val in
            val.cancel()
        }
    }

    var user: User {
        return manager.blockchainManager.user
    }

    var totalAmountInNative: String {
        let doubleAmt = convertAmountToNative()
        guard doubleAmt != 0 else { return "0" }
        let val = doubleAmt + manager.getMaxtransactionFee(amount: selectedMaxTransactionDataModel.amt)
        return "\(String(format: "%.6f", val))"
    }

    var totalAmountInUSD: String {
        let doubleAmt = convertAmountToNative()
        guard doubleAmt != 0 else { return "0" }
        let amt = doubleAmt + manager.getMaxtransactionFee(amount: selectedMaxTransactionDataModel.amt)
        let usdAmt = currentUSDRate * amt
        return "\(String(format: "%.6f", usdAmt))"
    }

    func convertAmtToUSD(amount: String) -> Double {
        guard let amt = Double(amount) else { return 0 }
        let convCurr = amt * currentUSDRate
        return convCurr
    }

    func checkBalanceError() {
        validate()
        let nativeFee = manager.getMaxtransactionFee(amount: selectedMaxTransactionDataModel.amt)
        if Double(convertAmountToNative()) + nativeFee  > userBalance {
            balanceError = true
            HapticGenerator.shared.generateHaptic(val: .error)
        } else {
            balanceError = false
        }
    }

    func checkRecipentAddressError() {
       sendingAddress = sendingAddress.replacingOccurrences(of: " ", with: "")
        if manager.checkRecipentAddressError(address: sendingAddress) {
            recipientAddressError = false
        } else {
            recipientAddressError = true
        }
    }

    init(manager: BlockChainProtocol) {
        self.manager = manager
        currencyInArr.append(manager.type.currencyValue)
        currencyInArr.append(.USD)
        currentCurrency = currencyInArr[0]
        selectItemToTransfer = manager.type

        manager.userBalancePublished.sink { [weak self] val in
            self?.userBalance = val
        }
        .store(in: &cancellables)
        manager.getBalance()
        Task {
            await manager.getMaxtransAPIModel()
            let val = await NetworkingClient.shared.getCurrentPrice(blockChain: manager.type, forCurrency: .USD)
            DispatchQueue.main.async { [weak self] in
                self?.currentUSDRate = val
            }
        }
    }

    func validate() {
        if amount.numberOfOccurrencesOf(string: ".") > 1 {
            amount.removeLast()
        }
    }

    func enableDisableSendBtnCheck() -> Bool {
        return (sendingAddress.isEmpty || amount.isEmpty || Double(amount) ?? 0 == 0 || balanceError || recipientAddressError)
    }

    func transferAsset() async throws {
        let amountInNative = convertAmountToNative()
        do {
            loading.toggle()
            let val = try await manager.transferAsset(sendTo: sendingAddress, amount: amountInNative, maxTip: Double(selectedMaxTransactionDataModel.amt), gasLimit: 21000)
            transactionSuccess.toggle()
            lastTransactionHash = val
        } catch {
            print(error)
            loading.toggle()

            throw error
        }
        loading.toggle()
    }
}
