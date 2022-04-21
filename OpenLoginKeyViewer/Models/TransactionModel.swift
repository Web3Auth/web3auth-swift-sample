//
//  File.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import Foundation
import BigInt


struct MaxTransactionDataModel:Hashable,Identifiable{
    var id:Int
    var title:String
    var time:Double
    var amt:Double
    
    var maxTransAmtInEth:Double{
        TorusUtil.toEther(Gwie: BigUInt(amt) * 21000)
    }
    
    var timeInSec:Double{
        TorusUtil.timeMinToSec(val: time)
    }
    
    
}

struct ETHGasAPIResponseModel:Codable {
    let fast, fastest, safeLow, average: Double
    let speed, safeLowWait: Double
    let avgWait: Double
    let fastWait, fastestWait: Double
    
}

enum MaxTransactionModelEnum:Int{
    case fast
    case avg
    case slow
}
