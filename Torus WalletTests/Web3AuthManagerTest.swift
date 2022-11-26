//
//  AuthManagerTest.swift
//  OpenLoginKeyViewerTests
//
//  Created by Dhruv Jaiswal on 27/05/22.
//

import XCTest
@testable import Torus_Wallet

class Web3AuthManagerTest: XCTestCase {

    var web3AuthManager: AuthManager!

    override func setUp() {
        super.setUp()
        web3AuthManager = AuthManager(network: .mainnet)
    }

    func test_network_change() {
        let oldAuth = web3AuthManager.auth
        web3AuthManager.network = .testnet
        let newAuth = web3AuthManager.auth
        XCTAssertNotEqual(oldAuth, newAuth)
    }

    func test_getClientID() {
        XCTAssertEqual(web3AuthManager.getClientID(), "BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc")
    }

//    func test_login() async{
//        let exp = expectation(description: "Should login with google")
//        defer {
//            wait(for: [exp], timeout: 10)
//        }
//        do{
//             _ = try await web3AuthManager.login(provider: .GOOGLE)
//            exp.fulfill()
//        }
//        catch{
//            XCTFail()
//        }
//    }
//    
//    
//    func test_email_login() async{
//        let exp = expectation(description: "Should login with google")
//        defer {
//            wait(for: [exp], timeout: 10)
//        }
//        do{
//             _ = try await web3AuthManager.loginWithEmail(email: "dhruv@tor.us")
//            exp.fulfill()
//        }
//        catch{
//            XCTFail()
//        }
//    }

}
