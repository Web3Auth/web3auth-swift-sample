//
//  NetworkingClient.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 08/04/22.
//


import Foundation
import MobileCoreServices
import SystemConfiguration
import BigInt

class NetworkingClient{
    var session:URLSession
    var currentPriceETHCacheDict = [TorusSupportedCurrencies:Double]()
    var currentPriceSOLCacheDict = [TorusSupportedCurrencies:Double]()
    static let shared = NetworkingClient()
    
    private init(){
        session = URLSession.shared
    }
    
    
    func getCurrentPrice(blockChain:BlockchainEnum = .ethereum,forCurrency:TorusSupportedCurrencies)async -> Double{
        if blockChain == .solana{
            if let cachedValue = currentPriceSOLCacheDict[forCurrency] {
                return cachedValue
        }
        }
        else if blockChain == .ethereum{
            if let cachedValue = currentPriceETHCacheDict[forCurrency] {
                return cachedValue
        }
        }
        let urlStr = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(blockChain.shortName)&tsyms=\(forCurrency.rawValue)"
            let url = URL(string: urlStr)!
            do{
                let (data,_ ) = try await URLSession.shared.data(from: url)
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                      let val = json[blockChain.shortName] as? [String:Any],
                      let curr = val[forCurrency.rawValue] as? Double else{return 0}
                currentPriceETHCacheDict[forCurrency] = curr
                return curr
            }
            catch{
                return 0
            }
    
    }
    
    
    func getSuggestedGasFees() async throws -> [MaxTransactionDataModel]{
        let urlStr = "https://ethgasstation.info/api/ethgasAPI.json"
        let url = URL(string: urlStr)!
        do{
            let (data,_ ) = try await URLSession.shared.data(from: url)
            
            let val = try JSONDecoder().decode(ETHGasAPIResponseModel.self, from: data)
            let fast = MaxTransactionDataModel.init(id: 0, title: "Fast", time: val.fastestWait, amt: val.fastest/10)
            let avg =  MaxTransactionDataModel.init(id:1, title: "Average",time:val.fastWait, amt: val.fast/10)
            let slow = MaxTransactionDataModel.init(id: 2, title: "Slow", time: val.avgWait, amt: val.average/10)
            return [fast,avg,slow]
        }
        catch{
            throw NetworkingError.decodingError
        }
    }
    
    
    
    
}










