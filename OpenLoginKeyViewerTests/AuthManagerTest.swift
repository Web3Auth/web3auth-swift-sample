//
//  AuthManagerTest.swift
//  OpenLoginKeyViewerTests
//
//  Created by Dhruv Jaiswal on 27/05/22.
//

import XCTest
import Combine
@testable import OpenLoginKeyViewer

class AuthManagerTest: XCTestCase {

    var authManager:AuthManager!
    var user:User!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        authManager = AuthManager()
        user = User(privKey: "1e5ea0e87281f8cfeac1d3cfcfa0372808cb8fb6dff828e2cf908f01ddf84cca", ed25519PrivKey: "1e5ea0e87281f8cfeac1d3cfcfa0372808cb8fb6dff828e2cf908f01ddf84ccaa1eeb509903ea69e4adb27460e1bdbe8a1b1c4a2b4b9e6e332ce22b72c1ad9e0", userInfo: OpenLoginKeyViewer.User.UserInfo(name: "Dhruv Jaiswal", profileImage: Optional("https://lh3.googleusercontent.com/a/AATXAJwKM6a17hiwJXoxEAmsRHQF7Q3emWSpWKyZoEpN=s96-c"), typeOfLogin: "google", aggregateVerifier: Optional("tkey-google"), verifier: Optional("torus"), verifierId: Optional("dhruv@tor.us"), email: Optional("dhruv@tor.us")), currentBlockchain: OpenLoginKeyViewer.BlockchainEnum.ethereum)
    }
    
    func test_save_user(){
        authManager.saveUser(user: user)
        authManager.$currentUser.sink { saveUser in
            XCTAssertEqual(saveUser,self.user)
        }
        .store(in: &cancellables)
        authManager.getCurrentUser()
    }
    
    func test_solana_account(){
        authManager.saveUser(user: user)
        switch authManager.account{
        case .success(let account):
        XCTAssertNotNil(account)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_remove_user(){
        authManager.removeUser()
        XCTAssertNil(authManager.currentUser)
        
    }

}
