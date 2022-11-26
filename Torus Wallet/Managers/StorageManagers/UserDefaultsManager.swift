//
//  UserDefaultsManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 03/11/22.
//

import Foundation

class UserDefaultsManager: KeychainManagerProtocol {

    private let defaults = UserDefaults.standard
    static let shared = KeychainManager()

    private init() {}

    func get(key: ConfigConstantEnum) -> Data? {
        return defaults.data(forKey: key.key)
    }

    func delete(key: ConfigConstantEnum) {
        defaults.removeObject(forKey: key.key)
    }

    func save(key: ConfigConstantEnum, val: Data) {
        defaults.set(val, forKey: key.key)
    }
}
