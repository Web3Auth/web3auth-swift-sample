//
//  UserModel.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 03/11/22.
//

import Foundation
import web3
import Web3Auth

struct User: Equatable, Codable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.privKey == rhs.privKey
    }

    public let privKey: String
    public let ed25519PrivKey: String
    public let userInfo: UserInfo
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
        public let email: String
    }
}

var DummyUser: User {
    return User(privKey: "", ed25519PrivKey: "", userInfo: .init(name: "Dhruv", profileImage: "", typeOfLogin: "Google", aggregateVerifier: "", verifier: "", verifierId: "", email: "Dhruv@tor.us"))
}
