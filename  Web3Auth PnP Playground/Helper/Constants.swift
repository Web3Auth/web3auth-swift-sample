//
//  Constants.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import Foundation

struct UpdationTimeConstants {
    static var balanceUpdation: TimeInterval = 20 // every 20 seconds
    static var convRateUpdation: TimeInterval = 300 // every 5 minutes
}

struct POPPINSFONTLIST {
    static let Regular = "Poppins-Regular"
    static let Bold = "Poppins-Bold"
    static let SemiBold = "Poppins-SemiBold"
    static let Medium = "Poppins-Medium"
}

struct DMSANSFONTLIST {
    static let Regular = "DMSans-Regular"
    static let Bold = "DMSans-Bold"
    static let Medium = "DMSans-Medium"
}

enum TorusSupportedCurrencies: String, CaseIterable, MenuPickerProtocol {
    case ETH
    case USD
    case INR
    case SOL
    case MATIC
    case BNB

    var name: String {
        return rawValue
    }
}

extension String: MenuPickerProtocol {
    var name: String {
        return self
    }
}
