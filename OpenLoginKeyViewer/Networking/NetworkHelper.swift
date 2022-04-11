//
//  NetworkHelper.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 08/04/22.
//

import Foundation
import MobileCoreServices
import SystemConfiguration

public enum HTTPMethod:String{
    case get
    case post
    case delete
    case put
}

public protocol URLType {

    /// The target's base `URL`.
    var baseURL: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }


    /// The headers to be used in the request.
    var headers: [String: String] { get }
    
    
    func requestCreator<T:Codable>(param:T) -> URLRequest
    func requestCreator() -> URLRequest
}


public enum CustomError:Error{
    
    case noInternetConnection
    case decodingError
    case somethingWentWrong
    case customErr(String)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("No Internet Connection", comment: "No-Internet")
        case .decodingError:
            return NSLocalizedString("Decoding Error", comment: "Decoding-Error")
        case .somethingWentWrong:
            return NSLocalizedString("Something Went Wrong", comment: "Something-WentWrong")
        case .customErr(let errStr):
            return NSLocalizedString(errStr, comment: errStr)
        }
}
}

class NetworkingHelper{
    
   static func checkReachablility() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        return isReachable
    }
    
   static func jsonToString(json: Any){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
}

