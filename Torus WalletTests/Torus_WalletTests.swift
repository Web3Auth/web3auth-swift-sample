//
//  Torus_WalletTests.swift
//  Torus WalletTests
//
//  Created by Dhruv Jaiswal on 19/11/22.
//

import XCTest
@testable import Torus_Wallet

final class Torus_WalletTests: XCTestCase {

    var authManager: AuthManager!
    var ethManager: EthManager!
    var solManager: SolanaManager!
    var web3AuthManager: AuthManager!

    override func setUp() {
        super.setUp()
        authManager = .init()
        ethManager = .init(authManager: authManager, network: .constant(.mainnet))!
        web3AuthManager = .init(network: .mainnet)
    }

    func test_get_current_price() {
        let exp = XCTestExpectation(description: "Should get Current price")
        defer {
            wait(for: [exp], timeout: 10)
        }
        Task {
            let val = await NetworkingClient.shared.getCurrentPrice(blockChain: .ethereum, forCurrency: .USD)
            XCTAssertNotEqual(0, val)
            exp.fulfill()
        }
    }

    func test_get_suggested_gas_price() async {
        do {
            let val = try await NetworkingClient.shared.getSuggestedGasFees()
            XCTAssertEqual(val.count, 3)
        } catch {
            XCTFail()
        }
    }
}
