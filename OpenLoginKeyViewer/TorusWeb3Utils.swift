//
//  TorusWeb3Utils.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 08/04/22.
//

import Foundation
import web3
import BigInt


public typealias Ether = Double
public typealias Wei = BigInt

public final class Converter {
    
    // NOTE: calculate wei by 10^18
    private static let etherInWei = pow(Double(10), 18)
    
    /// Convert Wei(BInt) unit to Ether(Decimal) unit
    public static func toEther(wei: Wei) throws -> Ether {
        guard let decimalWei = Double(wei.description) else {
            throw ConverterError.failed
        }
        return decimalWei / etherInWei
    }
    
    /// Convert Ether(Decimal) unit to Wei(BInt) unit
    public static func toWei(ether: Ether) throws -> Wei {
        guard let wei = Wei((ether * etherInWei).description) else {
            throw ConverterError.failed
        }
        return wei
    }
    
    /// Convert Ether(String) unit to Wei(BInt) unit
    public static func toWei(ether: String) throws -> Wei {
        guard let decimalEther = Double(ether) else {
            throw ConverterError.failed
        }
        return try toWei(ether: decimalEther)
    }
    
    // Only used for calcurating gas price and gas limit.
    public static func toWei(GWei: Int) -> Int {
        return GWei * 1000000000
    }
}


enum ConverterError:Error{
    case failed
}
