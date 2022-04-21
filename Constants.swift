//
//  Constants.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import Foundation


struct POPPINSFONTLIST {
    static let Regular = "Poppins-Regular"
    static let Bold = "Poppins-Bold"
    static let SemiBold = "Poppins-SemiBold"
    static let Medium = "Poppins-Medium"
}

struct DMSANSFONTLIST{
    static let Regular = "DMSans-Regular"
    static let Bold = "DMSans-Bold"
    static let Medium = "DMSans-Medium"
}

enum TorusSupportedCurrencies:String,CaseIterable,MenuPickerProtocol{
    
    case ETH
    case USD
    case INR
    
    var name: String{
        return self.rawValue
    }
}

enum TorusSupportedCyrptoCurrencies:String,CaseIterable{
    case ETH
}

enum BlockchainEnum:Int,CaseIterable,Hashable,MenuPickerProtocol{
    case ethereum, solana, binance, polygon
    
    var name:String{
        switch self {
        case .ethereum:
            return "Ethereum"
        case .solana:
            return "Solana"
        case .binance:
            return "Binance"
        case .polygon:
            return "Polygon"
        }
    }
}
