//
//  KeychainManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 02/11/22.
//

import Foundation
import KeychainSwift

enum ConfigConstantEnum {
    case configData
    case custom(String)
    case theme

    var key: String {
        switch self {
        case .configData:
            return "ConfigData"
        case let .custom(string):
            return string
        case .theme:
            return "theme"
        }
    }
}

protocol KeychainManagerProtocol {
    func get(key: ConfigConstantEnum) -> Data?

    func delete(key: ConfigConstantEnum)

    func save(key: ConfigConstantEnum, val: Data)
}

class KeychainManager: KeychainManagerProtocol {
    private let keychain = KeychainSwift()
    static let shared = KeychainManager()

    func get(key: ConfigConstantEnum) -> Data? {
        return keychain.getData(key.key)
    }

    func delete(key: ConfigConstantEnum) {
        keychain.delete(key.key)
    }

    func save(key: ConfigConstantEnum, val: Data) {
        keychain.set(val, forKey: key.key)
    }
}
