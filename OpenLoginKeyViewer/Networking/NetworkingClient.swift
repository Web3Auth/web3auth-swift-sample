//
//  NetworkingClient.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 08/04/22.
//


import Foundation
import MobileCoreServices
import SystemConfiguration

class NetworkingClient{
        var session:URLSession
        static let shared = NetworkingClient()
        
        private init(){
            session = URLSession.shared
        }
    
    
    func getCurrentPrice(forCurrency:TorusSupportedCurrencies)async -> Double{
        let urlStr = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH&tsyms=\(forCurrency.rawValue)"
        let url = URL(string: urlStr)!
        do{
        let (data,_ ) = try await URLSession.shared.data(from: url)
             guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                 let val = json[TorusSupportedCyrptoCurrencies.ETH.rawValue] as? [String:Any],
                 let curr = val[forCurrency.rawValue] as? Double else{return 0}
            return curr
        }
        catch{
            return 0
        }
    }
    
    
    
}


enum TorusSupportedCurrencies:String,CaseIterable,MenuPickerProtocol{
    var name: String{
        return self.rawValue
    }
    
    
    
    
    case ETH
    case USD
    case INR
    
    
}

enum TorusSupportedCyrptoCurrencies:String,CaseIterable{
    case ETH
}

