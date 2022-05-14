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
    case SOL
    
    var name: String{
        return self.rawValue
    }
}

enum TorusSupportedCyrptoCurrencies:String,CaseIterable{
    case ETH
    case SOL
}

enum BlockchainEnum:Int,CaseIterable,Hashable,MenuPickerProtocol,Codable{
    case ethereum, solana
    
    var name:String{
        switch self {
        case .ethereum:
            return "Ethereum"
        case .solana:
            return "Solana"
    }
    
}
    
    var shortName:String{
        switch self {
        case .ethereum:
            return "ETH"
        case .solana:
            return "SOL"
        }
    }
        
    var addressStr:String{
            switch self {
            case .ethereum:
                return "ETH Address"
            case .solana:
                return "SOL Address"
            }
    }
    
    var sampleAddress:String{
        switch self {
        case .ethereum:
            return "0xC951C5A85BE62F1Fe9337e698349bD7"
        case .solana:
            return "Bu7kgguFArj5qhQY8xGk1dEyRWpoeSaU9XT1FYUCkHom"
        }
    }
    
    var currencyValue:TorusSupportedCurrencies{
        switch self {
        case .ethereum:
            return .ETH
        case .solana:
            return .SOL
        }
    }
    
    func allTransactionURL(address:String) -> URL?{
        switch self {
        case .ethereum:
            return URL(string: "https://ropsten.etherscan.io/address/\(address)")
        case .solana:
            return URL(string: "https://explorer.solana.com/address/\(address)?cluster=devnet")
        }
    }
    
    func transactionURL(tx:String) -> URL?{
        switch self {
        case .ethereum:
            return URL(string: "https://ropsten.etherscan.io/tx/\(tx)")
        case .solana:
            return URL(string: "https://explorer.solana.com/tx/\(tx)/?cluster=devnet")
        }
    }
    
    var urlLinkName:String{
        switch self {
        case .ethereum:
            return "Etherscan"
        case .solana:
            return "Solana Explorer"
        }
    }
    
}

extension String:MenuPickerProtocol{
    var name: String {
        return self
    }
    
    
}
