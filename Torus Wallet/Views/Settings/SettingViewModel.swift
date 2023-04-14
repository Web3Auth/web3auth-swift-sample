//
//  SettingViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/11/22.
//

import Combine
import SwiftUI

class SettingVM: ObservableObject {
    var blockchain: BlockchainEnum {
        manager.type
    }
    var user: User {
        blockchainManager.user
    }

    private var blockchainManager: BlockchainManagerProtocol
    private var manager: BlockChainProtocol
    private var cancellables: Set<AnyCancellable> = []
    @EnvironmentObject var settingsManager: SettingsManager
    init(blockchainManager: BlockchainManagerProtocol) {
        self.blockchainManager = blockchainManager
        manager = blockchainManager.manager
        blockchainManager.blockchainDidChange.sink { completionVal in
            print(completionVal)
        } receiveValue: {[unowned self] manager in
            self.manager = blockchainManager.manager
            objectWillChange.send()
        }.store(in: &cancellables)
    }

    func changeBlockchain(val: BlockchainEnum) {
        blockchainManager.changeBlockChain(blockchain: val)
    }

    func changeTheme(val: ColorScheme) {
        settingsManager.changeColorSchemeTo(val)
    }

    func logout() {
        manager.logout()
    }
}
