//
//  Enviroment.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 25/03/22.
//

import Foundation
import Web3Auth


class Env{
    static let shared = Env()
    private var clientID = "BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc"
    private var network:Network = .mainnet
    
    func getClientID() -> String{
        return clientID
    }
    
    func changeNetwork(net:Network){
        network = net
    }
    
    func getCurrentNetwork() -> Network{
        return network
    }
}
