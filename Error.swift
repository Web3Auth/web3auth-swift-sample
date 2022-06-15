//
//  Error.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 15/06/22.
//

import Solana
import Foundation
import TweetNacl
import CTweetNacl

extension SolanaError:LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .notFoundProgramAddress:
            return "Not found program address"
        case .invalidRequest(let reason):
            return reason ?? ""
        case .invalidResponse(let responseError):
            return responseError.message ?? ""
        case .socket(let error):
            return error.localizedDescription
        case .couldNotRetriveAccountInfo:
            return "Could not retrive account info"
        case .other(let string):
            return string
        case .nullValue:
            return "Null Value"
        case .couldNotRetriveBalance:
            return "Could not retrive balance"
        case .blockHashNotFound:
            return "BlockHash not found"
        case .invalidPublicKey:
            return "Invalid Public Key"
        case .invalidMNemonic:
            return "Invalid MNemonic"
        }
    }
}

