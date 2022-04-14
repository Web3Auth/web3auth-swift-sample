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
    
    
    func getSuggestedGasFees() async throws -> ETHGasAPIModel{
        let urlStr = "https://ethgasstation.info/api/ethgasAPI.json"
        let url = URL(string: urlStr)!
        do{
            let (data,_ ) = try await URLSession.shared.data(from: url)
            
            let val = try JSONDecoder().decode(ETHGasAPIModel.self, from: data)
            print(val)
            return val
        }
        catch{
            throw CustomError.decodingError
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


struct ETHGasAPIModel:Codable {
    let fast, fastest, safeLow, average: Double
    let speed, safeLowWait: Double
    let avgWait: Double
    let fastWait, fastestWait: Double
    

    
    var fastEstInEth:Double{
        return TorusUtil.toEther(Gwie: BigUInt(fastest/10) * 21000)
    }
    
    var averageInEth:Double{
        return TorusUtil.toEther(Gwie: BigUInt(fast/10) * 21000)
    }
    
    var slowInEth:Double{
        return  TorusUtil.toEther(Gwie: BigUInt(fast/10) * 21000)
    }
    
    var fastTimeInSec:Double{
        return TorusUtil.timeMinToSec(val: fastestWait)
    }
    
    var avgTimeInSec:Double{
        return TorusUtil.timeMinToSec(val: fastWait)
    }
    
    var slowTimeInSec:Double{
        return TorusUtil.timeMinToSec(val: Double(avgWait))
    }
}

extension ETHGasAPIModel{
   mutating func valueBasedOnIndex(val:Int) -> [Double]{
        var amt:Double = 0
        var time:Double = 0
        if val == 0{
           amt = fastEstInEth
            time = fastTimeInSec
        }
        else if val == 1{
            amt = averageInEth
            time = avgTimeInSec
        }
        else{
           amt = slowInEth
          time = slowTimeInSec
        }
        return [amt,time]
    }
}



