//
//  AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import Foundation
import KeychainSwift
import Solana
import SwiftUI
import web3
import Web3Auth

class AuthManager: ObservableObject {
    var currentBlockChain: BlockchainEnum = .ethereum
    var privatekeyInfoString = "privateKey"
    var userInfoString = "userInfo"
    var isUserLoggedIn = false
    @Published var currentUser: User?
    let keychain = KeychainSwift()

    init() {
        getCurrentUser()
    }

    func getCurrentUser() {
        do {
            guard let data = keychain.getData(userInfoString) else { return }
            let user = try JSONDecoder().decode(User.self, from: data)
            currentBlockChain = user.currentBlockchain
            currentUser = user
        } catch {
            print(error)
        }
    }

    func saveUser(user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            keychain.set(data, forKey: userInfoString)
        } catch {
            print(error)
        }
        currentUser = user
    }

    func removeUser() {
        keychain.delete(userInfoString)
        currentUser = nil
    }
}

//Ethereum login
extension AuthManager: EthereumKeyStorageProtocol {
    func storePrivateKey(key: Data) throws {
    }

    func loadPrivateKey() throws -> Data {
        currentUser?.privKey.web3.hexData ?? String("1e5ea0e87281f8cfeac1d3cfcfa0372808cb8fb6dff828e2cf908f01ddf84cca").web3.hexData!
    }
}

// Solana login
extension AuthManager: SolanaAccountStorage {
    func save(_ account: Account) -> Swift.Result<Void, Error> {
        return .success(())
    }

    var account: Swift.Result<Account, Error> {
        if currentUser != nil, let account = Account(secretKey: currentUser!.ed25519PrivKey.web3.hexData ?? Data()) {
            return .success(account)
        } else {
            return .failure(SolanaError.accountFailed)
        }
    }

    func clear() -> Swift.Result<Void, Error> {
        removeUser()
        return .success(())
    }
}

public struct User: Codable {
    public let privKey: String
    public let ed25519PrivKey: String
    public let userInfo: UserInfo
    var currentBlockchain: BlockchainEnum
    public var firstName: String {
        return String(userInfo.name.split(separator: " ").first ?? "")
    }

    public var typeOfImage: String {
        let typeOflogin = userInfo.typeOfLogin
        let img = Web3AuthProvider(rawValue: typeOflogin)?.img ?? ""
        return img
    }

    public var typeOfDisabledImage: String {
        let typeOflogin = userInfo.typeOfLogin
        let img = "\(Web3AuthProvider(rawValue: typeOflogin)?.img ?? "")Disabled"
        return img
    }

    public struct UserInfo: Codable {
        public let name: String
        public let profileImage: String?
        public let typeOfLogin: String
        public let aggregateVerifier: String?
        public let verifier: String?
        public let verifierId: String?
        public let email: String?
    }
}
