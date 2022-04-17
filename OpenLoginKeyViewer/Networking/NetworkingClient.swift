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
    var currentPriceCacheDict = [TorusSupportedCurrencies:Double]()
    static let shared = NetworkingClient()
    
    private init(){
        session = URLSession.shared
    }
    
    
    func getCurrentPrice(forCurrency:TorusSupportedCurrencies)async -> Double{
        if let cachedValue = currentPriceCacheDict[forCurrency] {
            return cachedValue
        }
        else{
            let urlStr = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH&tsyms=\(forCurrency.rawValue)"
            let url = URL(string: urlStr)!
            do{
                let (data,_ ) = try await URLSession.shared.data(from: url)
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                      let val = json[TorusSupportedCyrptoCurrencies.ETH.rawValue] as? [String:Any],
                      let curr = val[forCurrency.rawValue] as? Double else{return 0}
                currentPriceCacheDict[forCurrency] = curr
                return curr
            }
            catch{
                return 0
            }
        }
    }
    
    
    func getSuggestedGasFees() async throws -> MaxTransactionModel{
        let urlStr = "https://ethgasstation.info/api/ethgasAPI.json"
        let url = URL(string: urlStr)!
        do{
            let (data,_ ) = try await URLSession.shared.data(from: url)
            
            let val = try JSONDecoder().decode(ETHGasAPIResponseModel.self, from: data)
            let fast = MaxTransactionDataModel.init(time: val.fastestWait, amt: val.fastest/10)
            let avg =  MaxTransactionDataModel.init(time: val.fastWait, amt: val.fast/10)
            let slow = MaxTransactionDataModel.init(time: val.avgWait, amt: val.average/10)

            
            let model = MaxTransactionModel(fast: fast, avg: avg, slow: slow)
            return model
        }
        catch{
            throw NetworkingError.decodingError
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

enum MaxTransactionModelEnum:Int{
    case fast
    case avg
    case slow
}

struct MaxTransactionDataModel{
    var time:Double
    var amt:Double
    
    var maxTransAmtInEth:Double{
        TorusUtil.toEther(Gwie: BigUInt(amt) * 21000)
    }
    
    var timeInSec:Double{
        TorusUtil.timeMinToSec(val: time)
    }
    
    
}
struct MaxTransactionModel{
   

    
    var fast:MaxTransactionDataModel
    var avg:MaxTransactionDataModel
    var slow:MaxTransactionDataModel
    
    func valFromType(type:MaxTransactionModelEnum) -> MaxTransactionDataModel{
        switch type {
        case .fast:
            return fast
        case .avg:
            return avg
        case .slow:
            return slow
        }
    }
    
    
}




struct ETHGasAPIResponseModel:Codable {
    let fast, fastest, safeLow, average: Double
    let speed, safeLowWait: Double
    let avgWait: Double
    let fastWait, fastestWait: Double
    
}




