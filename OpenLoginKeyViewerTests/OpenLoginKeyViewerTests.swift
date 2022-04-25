//
//  OpenLoginKeyViewerTests.swift
//  OpenLoginKeyViewerTests
//
//  Created by Michael Lee on 7/1/2022.
//

import XCTest
@testable import OpenLoginKeyViewer

class OpenLoginKeyViewerTests: XCTestCase {

    var authManager:AuthManager!
    var ethManager:EthManager!
    var web3AuthManager:Web3AuthManager!
    
    
    override func setUp() {
        super.setUp()
        authManager = .init()
        ethManager = .init(authManager: authManager, network: .constant(.mainnet))!
        web3AuthManager = .init(network: .mainnet)
    }

    
    override func setUpWithError() throws {
      
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_getSuggestedGasPrice_API(){
        Task{
        let vm = TransferAssetViewModel(ethManager: ethManager)
            vm.maxTransactionDataModel.publisher.sink { arr in
                XCTAssertEqual(, <#T##expression2: Equatable##Equatable#>)
            }
        }
        
    }
    
    
    @MainActor func test_transfer_USD_conversion(){
        let vm = TransferAssetViewModel(ethManager: ethManager)
        vm.amount = "100"
        vm.currentCurrency = .USD
        vm.currentUSDRate = 75
        let exp1 = Double(vm.amount)! / vm.currentUSDRate
        print(vm.convertAmountToETH())
        XCTAssertEqual(exp1, vm.convertAmountToETH())
    }
    
    @MainActor func test(){
        let vm = TransferAssetViewModel(ethManager: ethManager)
        vm.amount = "100"
        vm.currentCurrency = .USD
        vm.currentUSDRate = 75
        let exp1 = Double(vm.amount)! / vm.currentUSDRate
        print(vm.convertAmountToETH())
        XCTAssertEqual(exp1, vm.convertAmountToETH())
    }
    
    



}
