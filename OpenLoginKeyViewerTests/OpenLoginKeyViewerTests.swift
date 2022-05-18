//
//  OpenLoginKeyViewerTests.swift
//  OpenLoginKeyViewerTests
//
//  Created by Michael Lee on 7/1/2022.
//

@testable import OpenLoginKeyViewer
import web3
import XCTest

class OpenLoginKeyViewerTests: XCTestCase {
    var authManager: AuthManager!
    var ethManager: EthManager!
    var solManager: SolanaManager!
    var web3AuthManager: Web3AuthManager!

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
        do{
            let val = try await NetworkingClient.shared.getSuggestedGasFees()
            XCTAssertEqual(val.count, 3)
        }catch{
            XCTFail()
        }
           
    }
    
    
    
    


    

   



   


//    @MainActor func test_transfer_USD_conversion(){
//        let vm = TransferAssetViewModel(manager: ethManager)
//        vm.amount = "100"
//        vm.currentCurrency = .USD
//        vm.currentUSDRate = 75
//        let exp1 = Double(vm.amount)! / vm.currentUSDRate
//        print(vm.con)
//        XCTAssertEqual(exp1, vm.convertAmountToETH())
//    }
}
