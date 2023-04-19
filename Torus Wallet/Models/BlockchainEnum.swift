//
//  File.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 02/11/22.
//

import Foundation
import Solana

enum BlockchainEnum: Int, CaseIterable, Hashable, MenuPickerProtocol, Codable, Identifiable {
    var id: String { UUID().uuidString }

    case ETHMainnet
    case PolygonMainnet
    case PolygonTestnet
    case BinanceMainnet
    case Goerli
    case SOLMainnet
    case SOLtestnet
    case SOLdevenet

    var name: String {
        switch self {
        case .ETHMainnet:
            return "Ethereum Mainnet"
        case .PolygonMainnet:
            return "Polygon Mainnet"
        case .BinanceMainnet:
            return "Binance Mainnet"
        case .Goerli:
            return "Goerli Testnet"
        case .SOLMainnet:
            return "Solana Mainnet"
        case .SOLtestnet:
            return "Solana Testnet"
        case .SOLdevenet:
            return "Solana Devnet"
        case .PolygonTestnet:
            return "Polygon Testnet"
        }
    }

    var RPCEndpoint: URL {
        switch self {
        case .ETHMainnet:
            return URL(string: "https://rpc.ankr.com/eth")!
        case .PolygonMainnet:
            return URL(string: "https://rpc.ankr.com/polygon")!
        case .BinanceMainnet:
            return URL(string: "https://rpc.ankr.com/bsc")!
        case .Goerli:
            return URL(string: "https://rpc.ankr.com/eth_goerli")!
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return URL(string: "https://rpc.ankr.com/solana")!
        case .PolygonTestnet:
            return URL(string: "https://rpc.ankr.com/polygon_mumbai")!
        }
    }

    var chainID: Int {
        switch self {
        case .ETHMainnet:
            return 1
        case .PolygonMainnet:
            return 137
        case .BinanceMainnet:
            return 56
        case .Goerli:
            return 5
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return 0
        case .PolygonTestnet:
            return 80001
        }
    }

    var shortName: String {
        switch self {
        case .ETHMainnet, .PolygonMainnet, .BinanceMainnet, .Goerli, .PolygonTestnet:
            return "ETH"
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return "SOL"
        }
    }

    var addressStr: String {
        switch self {
        case .ETHMainnet, .PolygonMainnet, .BinanceMainnet, .Goerli, .PolygonTestnet:
            return "ETH Address"
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return "SOL Address"
        }
    }

    var sampleAddress: String {
        switch self {
        case .ETHMainnet, .PolygonMainnet, .BinanceMainnet, .Goerli, .PolygonTestnet:
            return "0xC951C5A85BE62F1Fe9337e698349bD7"
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return "Bu7kgguFArj5qhQY8xGk1dEyRWpoeSaU9XT1FYUCkHom"
        }
    }

    var currencyValue: TorusSupportedCurrencies {
        switch self {
        case .ETHMainnet, .PolygonMainnet, .BinanceMainnet, .Goerli, .PolygonTestnet:
            return .ETH
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return .SOL
        }
    }

    var baseURL: String {
        switch self {
        case .ETHMainnet:
            return "https://etherscan.io/"
        case .PolygonMainnet:
            return "https://polygonscan.com/"
        case .PolygonTestnet:
            return "https://mumbai.polygonscan.com/"
        case .BinanceMainnet:
            return "https://bscscan.com/"
        case .Goerli:
            return "https://goerli.etherscan.io/"
        case .SOLMainnet:
            return "https://explorer.solana.com/"
        case .SOLtestnet:
            return "https://explorer.solana.com/"
        case .SOLdevenet:
            return "https://explorer.solana.com/"
        }
    }

    var addressURL: String {
        return self.baseURL.appending("address/")
    }

    var transactionURL: String {
        return self.baseURL.appending("tx/")
    }

    func allTransactionURL(address: String) -> URL? {
        var str = addressURL.appending(address)
        switch self {
        case .SOLtestnet:
            str.append("?cluster=testnet")
        case .SOLdevenet:
            str.append("?cluster=devnet")
        default:
            str.append("")
        }
        return URL(string: str)
    }

    func transactionURL(tx: String) -> URL? {
        var str = addressURL.appending(tx)
        switch self {
        case .SOLtestnet:
            str.append("?cluster=testnet")
        case .SOLdevenet:
            str.append("?cluster=devnet")
        default:
            str.append("")
        }
        return URL(string: str)
    }

    var urlLinkName: String {
        switch self {
        case .ETHMainnet, .PolygonMainnet, .BinanceMainnet, .Goerli, .PolygonTestnet:
            return "Etherscan"
        case .SOLMainnet, .SOLtestnet, .SOLdevenet:
            return "Explorer"
        }
    }

    func createBlockChainManagerFactory(blockManager: BlockchainManager) -> BlockChainProtocol? {
        switch self {
        case .ETHMainnet, .PolygonMainnet, .BinanceMainnet, .Goerli, .PolygonTestnet:
            return EthManager(blockchainManager: blockManager, clientURL: self.RPCEndpoint, type: self, chainID: self.chainID)
        case .SOLMainnet:
            return SolanaManager(blockchainManager: blockManager, endpoint: .mainnetBetaSolana, type: self)
        case .SOLtestnet:
            return SolanaManager(blockchainManager: blockManager, endpoint: .testnetSolana, type: self)
        case .SOLdevenet:
            return SolanaManager(blockchainManager: blockManager, endpoint: .devnetSolana, type: self)
        }
    }

}
