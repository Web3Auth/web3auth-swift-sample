//
//  CustomAuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 15/05/22.
//

import Foundation
import CustomAuth
import Web3Auth

class CustomAuthLogin:ObservableObject{
    
    private var clientID:String = "BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc"
    @Published var network:Network{
        didSet{
           // auth = Web3Auth(.init(clientId: clientID, network: network))
        }
    }

    
    init(network:Network){
        self.network = network
    }
    
    func getClientID() -> String{
        return clientID
    }
    
    
    func login(_ verifier: Verifier) -> Void {
        let customAuth = CustomAuth(
            aggregateVerifierType: .singleLogin,
            aggregateVerifierName: verifier.verifier,
            subVerifierDetails: [SubVerifierDetails(
                loginType: .web,
                loginProvider: LoginProviders(rawValue: verifier.typeOfLogin)!,
                clientId: verifier.clientId,
                verifierName: verifier.verifier,
                redirectURL: data.redirectUri,
                browserRedirectURL: data.browserRedirectUri,
                extraQueryParams: getVerifierExtraQueryParams(verifier),
                jwtParams: getVerifierJwtParams(verifier)
            )],
            network: .ROPSTEN
        )
        
       // result = nil
      //  showResult = true
        
        customAuth.triggerLogin(browserType: .external)
            .done { data in
                print(data)

            }.catch { err in
               // showResult = false
                print(err)
            }
    }
}


struct Verifier: Hashable, Codable {
    var displayName: String? = nil
    var typeOfLogin: String
    var verifier: String
    var clientId: String
}

struct AggregateVerifier: Hashable, Codable {
    var displayName: String? = nil
    var id: String
    var verifiers: [Verifier]
}

func getVerifierJwtParams(_ verifier: Verifier) -> [String:String] {
    switch verifier.typeOfLogin {
    case "apple", "github", "linkedin", "twitter", "line", "Username-Password-Authentication":
        return ["domain": data.proxyDomain]
    case "jwt":
        return [
            "domain": data.proxyDomain,
            "isVerifierIdCaseSensitive": "false"
        ]
    default:
        return [:]
    }
}

func getVerifierExtraQueryParams(_ verifier: Verifier) -> [String:String] {
    switch verifier.typeOfLogin {
    case "jwt":
        return [
            "verifier_id_field": "name"
        ]
    default:
        return [:]
    }
}


struct AppData: Hashable, Codable {
    var browserRedirectUri: String
    var redirectUri: String
    var proxyDomain: String
    var verifiers: [Verifier]
    var aggregateVerifier: AggregateVerifier
    var appleVerifier: String
}

var data: AppData = loadPropertylist("Auth")
var verifiers = data.verifiers

func loadPropertylist<T: Decodable>(_ filename: String) -> T {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "plist")
    else {
        fatalError("Couldn't find \(filename).plist in main bundle.")
    }

    let data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Couldn't load \(filename).plist from main bundle: \(error)")
    }

    do {
        let decoder = PropertyListDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self): \(error)")
    }
}
