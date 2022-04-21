//
//  AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import Foundation
import KeychainSwift
import Web3Auth
import web3
import SwiftUI
class AuthManager:ObservableObject,EthereumKeyStorageProtocol{
    
    
    func storePrivateKey(key: Data) throws {
        
    }
    
    func loadPrivateKey() throws -> Data {
        currentUser?.privKey.web3.hexData ?? String("1e5ea0e87281f8cfeac1d3cfcfa0372808cb8fb6dff828e2cf908f01ddf84cca").web3.hexData!
    }
    
    var privatekeyInfoString = "privateKey"
    var userInfoString = "userInfo"
    var isUserLoggedIn = false
 
    @Published var currentUser:User?
    let keychain = KeychainSwift()
    
     init(){
        getCurrentUser()
    }
    
    func getCurrentUser(){
        do{
            guard let data = keychain.getData(userInfoString) else{return}
            let user = try JSONDecoder().decode(User.self, from: data)
            currentUser = user
        }
        catch{
            print(error)
        }
    }
    

    func saveUser(user:User){
        do{
        let data = try JSONEncoder().encode(user)
        keychain.set(data, forKey: userInfoString)
            currentUser = user
        }
        catch{
            print(error)
        }
    }
    
    func removeUser(){
        keychain.delete(userInfoString)
        currentUser = nil
    }
}


public struct User: Codable {
    public let privKey: String
    public let ed25519PrivKey: String
    public let userInfo: UserInfo
    public var firstName:String{
        return String(userInfo.name.split(separator: " ").first ?? "")
    }
    
    public var typeOfImage:String{
        let typeOflogin = userInfo.typeOfLogin
        let img = Web3AuthProvider(rawValue: typeOflogin)?.img ?? ""
        return img
    }
    
    public var typeOfDisabledImage:String{
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



