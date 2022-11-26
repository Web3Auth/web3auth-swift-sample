import Combine
@testable import OpenLoginKeyViewer
import web3
import XCTest

class SOLManagerTest: XCTestCase {
    var authManager: AuthManager!
    var solManager: SolanaManager!
    var web3AuthManager: AuthManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        authManager = .init()
        solManager = .init(authManager: authManager)!
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
        solManager.userBalancePublished.dropFirst().sink { val in
            XCTAssertNotEqual(val, 0)
            exp.fulfill()
        }.store(in: &cancellables)
        solManager.getBalance()
    }

    func test_sign_message() async {
        let val = await solManager.signMessage(message: "Hello")
        XCTAssert(!val.isEmpty)
    }

    func test_transfer_pass() {
        let exp = XCTestExpectation(description: "Should pass transfer")
        defer {
            wait(for: [exp], timeout: 10)
        }
        Task {
            do {
                let val = try await solManager.transferAsset(sendTo: "3vsU1mG5CTQWk1eYFkoo3mszrk723bABZWukk6P26a26", amount: 0.1, maxTip: 0)
                print(val)
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
                _ = try await solManager.transferAsset(sendTo: "", amount: 100, maxTip: 20)
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
        solManager.$maxTransactionDataModel.dropFirst().sink { value in
            XCTAssertEqual(value.count, 1)
            exp.fulfill()
        }
        .store(in: &cancellables)
        Task {
            await solManager.getMaxtransAPIModel()
        }
    }

    func test_check_latest_block_changed() async {
        let exp = XCTestExpectation(description: "Should pass transfer")
        defer {
            wait(for: [exp], timeout: 10)
        }

        let val = await solManager.getBlock()
        XCTAssertEqual(val, true)
        exp.fulfill()
    }
}
