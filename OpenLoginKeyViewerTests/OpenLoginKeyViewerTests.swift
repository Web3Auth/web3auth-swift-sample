//
//  OpenLoginKeyViewerTests.swift
//  OpenLoginKeyViewerTests
//
//  Created by Michael Lee on 7/1/2022.
//

import XCTest
import web3
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
    
     func test_transfer_pass(){

            let exp = XCTestExpectation(description: "Should pass transfer")
                defer{
                    wait(for: [exp], timeout: 10)
                }
            Task{
                do{
                _ = try await ethManager.transferAsset(sendTo: EthereumAddress("0x1776e71Bb1956c46D9bBA247cd979B1c887dE633"), amount: 100000, maxTip: 20)
                    exp.fulfill()
                }
                catch{
                    XCTFail()
                }
            
        }
        
    }
    
    func test_sign_message() {
            let val = ethManager.signMessage(message: "Hello")
            XCTAssertEqual(val, "0x379ce172e46791d5869a5cbda990737c6b10484ececa1b27bb90efbf5d3b0ede013bd627310fda9c3d727b3d8d1dd83fe0b9c423f405b88862d234727dd474b101")
        
    }
    
    func test_get_balance(){
        let exp = XCTestExpectation(description: "Should get balance")
            defer{
                wait(for: [exp], timeout: 10)
            }
        Task{
            do{
            _ = try await ethManager.getBalance()
                exp.fulfill()
            }
            catch{
                XCTFail()
              
            }
        }
    }
    
     func test_transfer_fail(){
         let exp = XCTestExpectation(description: "Should fail transfer")
            defer{
                wait(for: [exp], timeout: 10)
            }
        Task{
            do{
            _ = try await ethManager.transferAsset(sendTo: EthereumAddress(""), amount: 100, maxTip: 20)
                XCTFail()
            }
            catch{
                exp.fulfill()
            }
        
        }
    }
    
    func test_suggestedGasFeeAPI(){
        let exp = XCTestExpectation(description: "Should get suggestedGas price")
            defer{
                wait(for: [exp], timeout: 10)
            }
        Task{
            do{
            let val = try await NetworkingClient.shared.getSuggestedGasFees()
                XCTAssertEqual(val.count, 3)
                exp.fulfill()
            }
            catch{
             XCTFail()
            }
        }
    }
    
    
    func test_get_current_price(){
        let exp = XCTestExpectation(description: "Should get Current price")
            defer{
                wait(for: [exp], timeout: 10)
            }
        Task{
                let val = await NetworkingClient.shared.getCurrentPrice(forCurrency: .USD)
                XCTAssertNotEqual(0, val)
                exp.fulfill()

        }
    }
    

//
//    @MainActor func test_transfer_USD_conversion(){
//        let vm = TransferAssetViewModel(manager: ethManager)
//        vm.amount = "100"
//        vm.currentCurrency = .USD
//        vm.currentUSDRate = 75
//        let exp1 = Double(vm.amount)! / vm.currentUSDRate
//        print(vm.convertAmountToETH())
//        XCTAssertEqual(exp1, vm.convertAmountToETH())
//    }
    
 
    
    



}
