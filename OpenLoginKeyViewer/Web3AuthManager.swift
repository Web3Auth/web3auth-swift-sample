//
//  web3AuthManager.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 30/03/22.
//

import Foundation
import Web3Auth

class Web3AuthManager:ObservableObject{
    
    private var clientID:String = "BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc"
    @Published var network:Network{
        didSet{
            auth = Web3Auth(.init(clientId: clientID, network: network))
        }
    }
    var auth:Web3Auth
    
    init(network:Network){
        self.network = network
        auth = Web3Auth(.init(clientId: clientID, network: network))
    }
    
    func getClientID() -> String{
        return clientID
    }
    
}
