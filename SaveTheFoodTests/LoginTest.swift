//
//  LoginTest.swift
//  SaveTheFoodTests
//
//  Created by Andrea Franco on 2020-09-07.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import XCTest
import Firebase
@testable import SaveTheFood

class LoginTest: XCTestCase, UserManagerDelegate {
    
    private var userManager: UserManeger?
    private var expectation: XCTestExpectation?
    private var user: AuthDataResult?
    
    override func setUp() {
        userManager = UserManeger()
        userManager?.delegate = self
        self.expectation = XCTestExpectation(description: "Test")
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }
    
    func test_login_successful() {
        userManager?.doLoginWithEmailPass(email: "a@a.com", pass: "aaaaa")
        
        // We need a timeout, doesn't work
        let expectation = self.expectation(description: "Scaling")
        XCTAssertNotNil(self.user)
    }
    
    func didRequestUser(_ userManager: UserManeger, user: AuthDataResult) {
        self.user = user
    }
    
    func didFailWithError(error: String) {
        
    }

}
