//
//  AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import Foundation
import KeychainSwift
import Web3Auth

class AuthManager:ObservableObject{
    
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



