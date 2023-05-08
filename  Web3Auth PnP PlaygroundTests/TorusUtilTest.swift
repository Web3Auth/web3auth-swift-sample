//
//  TorusUtilTest.swift
//  OpenLoginKeyViewerTests
//
//  Created by Dhruv Jaiswal on 27/05/22.
//

import XCTest
@testable import Web3Auth_PnP_Playground

class TorusUtiltest: XCTestCase {

    func testConverter() {
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("100000000000000")), 0.0001)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("1000000000000000")), 0.001)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("10000000000000000")), 0.01)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("100000000000000000")), 0.1)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("1000000000000000000")), 1)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("10000000000000000000")), 10)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("100000000000000000000")), 100)
        XCTAssertEqual(TorusWeb3Utils.toEther(wei: Wei("1000000000000000000000")), 1000)
        XCTAssertEqual(TorusWeb3Utils.toWei(ether: Ether(0.0001)).description, "100000000000000")
        XCTAssertEqual(TorusWeb3Utils.toWei(GWei: 1), 1000000000)
        XCTAssertEqual(TorusWeb3Utils.toWei(GWei: 10), 10000000000)
        XCTAssertEqual(TorusWeb3Utils.toWei(GWei: 15), 15000000000)
        XCTAssertEqual(TorusWeb3Utils.toWei(GWei: 30), 30000000000)
        XCTAssertEqual(TorusWeb3Utils.toWei(GWei: 60), 60000000000)
        XCTAssertEqual(TorusWeb3Utils.toWei(GWei: 99), 99000000000)
    }

    func test_time_converter() {
        XCTAssertEqual(TorusWeb3Utils.timeMinToSec(val: 1), 60)
    }

    func test_ethAddress() {
        let ethAddress: String = "0x2d554f12bff804ba137546e5dd3c786f317c46b5"
        XCTAssertTrue(ethAddress.isValidEthAddress())
    }
}
