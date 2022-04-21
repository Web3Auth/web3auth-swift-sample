//
//  LoginMethodSelectionPageVM.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import SwiftUI
import Combine
import Web3Auth


class LoginMethodSelectionPageVM:ObservableObject{
    var web3AuthManager:Web3AuthManager
    var authManager:AuthManager
    @Published var showError = false
    @Published var showSuccess = false
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    @Published var userEmail:String = ""
    @Published var userInfo:Web3AuthState?{
        didSet{
            guard let safeuser = userInfo else{return}
            authManager.saveUser(user: .init(privKey: safeuser.privKey, ed25519PrivKey: safeuser.ed25519PrivKey, userInfo: .init(name: safeuser.userInfo.name, profileImage: safeuser.userInfo.profileImage, typeOfLogin: safeuser.userInfo.typeOfLogin, aggregateVerifier: safeuser.userInfo.aggregateVerifier, verifier: safeuser.userInfo.verifier, verifierId: safeuser.userInfo.verifierId, email: safeuser.userInfo.email)))
            isLoggedIn.toggle()
        }
    }
    init(web3AuthManager:Web3AuthManager,authManager:AuthManager){
        self.web3AuthManager = web3AuthManager
        self.authManager = authManager
    }
    
    func login(_ provider: Web3AuthProvider?) {
        web3AuthManager.auth.login(.init(loginProvider: provider?.rawValue)) {[unowned self]
            result in
                switch result{
                case .success(let model):
                    userInfo = model
                case .failure(let error):
                    print(error)
                    errorMessage = error.localizedDescription
                    showError.toggle()
                }
        }
    }
    
    func loginWithEmail(){
        if userEmail.invalidEmail(){
           errorMessage = "Invalid Email"
            showError.toggle()
       }
       else{
           let extraOptions = ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, login_hint: userEmail, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil)
           web3AuthManager.auth.login(.init(loginProvider: Web3AuthProvider.EMAIL_PASSWORDLESS.rawValue, extraLoginOptions:extraOptions)) {[unowned self] result in
               switch result{
               case .success(let model):
                   print(model)
                   userInfo = model
               case .failure(let error):
                   print(error)
                   errorMessage = error.localizedDescription
                   showError.toggle()
               }
           }
       }
       
   }
    
    
}
