//
//  SettingViewModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/11/22.
//

import Combine
import Foundation
import UIKit

class SettingVM: ObservableObject {
    var blockchain: BlockchainEnum {
        manager.type
    }
    var user: User {
        blockchainManager.user
    }

    @Published var themeMode: ThemeModes = .lightMode

    private var blockchainManager: BlockchainManagerProtocol
    private var manager: BlockChainProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var keyWindow: UIWindow?
    init(blockchainManager: BlockchainManagerProtocol) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        keyWindow = windowScene?.windows.first
       // themeMode = keyWindow?.overrideUserInterfaceStyle
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

    func logout() {
        manager.logout()
    }

    func changeThemeMode(val:ThemeModes) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
}
