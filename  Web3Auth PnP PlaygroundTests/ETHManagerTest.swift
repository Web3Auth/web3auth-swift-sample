//
//  ETHManagerTest.swift
//  OpenLoginKeyViewerTests
//
//  Created by Dhruv Jaiswal on 18/05/22.
//

import Combine
@testable import
import web3
import XCTest

class ETHManagerTest: XCTestCase {
    var authManager: AuthManager!
    var ethManager: EthManager!
    var web3AuthManager: AuthManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        authManager = .init()
        ethManager = .init(authManager: authManager, network: .constant(.mainnet))!
        web3AuthManager = .init(network: .mainnet)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getBalance() {
        let exp = XCTestExpectation(description: "Should get balance")
        defer {
            wait(for: [exp], timeout: 10)
        }
        ethManager.userBalancePublished.dropFirst().sink { val in
            XCTAssertNotEqual(val, 0)
            exp.fulfill()
        }.store(in: &cancellables)
        ethManager.getBalance()
    }

    func test_sign_message() async {
        let val = await ethManager.signMessage(message: "Hello")
        XCTAssertEqual(val, "0x379ce172e46791d5869a5cbda990737c6b10484ececa1b27bb90efbf5d3b0ede013bd627310fda9c3d727b3d8d1dd83fe0b9c423f405b88862d234727dd474b101")
    }

    func test_transfer_pass() {
        let exp = XCTestExpectation(description: "Should pass transfer")
        defer {
            wait(for: [exp], timeout: 10)
        }
        Task {
            do {
                let val = try await ethManager.transferAsset(sendTo: "0x1776e71Bb1956c46D9bBA247cd979B1c887dE633", amount: 0.01, maxTip: 20)
                exp.fulfill()
            } catch {
                XCTFail()
            }
        }
    }

    func test_transfer_fail() {
        let exp = XCTestExpectation(description: "Should fail transfer")
        defer {
            wait(for: [exp], timeout: 10)
        }
        Task {
            do {
                _ = try await ethManager.transferAsset(sendTo: "", amount: 100, maxTip: 20)
                XCTFail()
            } catch {
                exp.fulfill()
            }
        }
    }

    func test_get_max_transaction_fee() {
        let exp = XCTestExpectation(description: "Should pass transfer")
        defer {
            wait(for: [exp], timeout: 10)
        }
        ethManager.$maxTransactionDataModel.dropFirst().sink { value in
            XCTAssertEqual(value.count, 3)
            exp.fulfill()
        }
        .store(in: &cancellables)
        Task {
            await ethManager.getMaxtransAPIModel()
        }
    }

    func test_check_latest_block_changed() async {
        let exp = XCTestExpectation(description: "Should pass transfer")
        defer {
            wait(for: [exp], timeout: 10)
        }

        let val = await ethManager.checkLatestBlockChanged()
        XCTAssertEqual(val, true)
        exp.fulfill()
    }
}
