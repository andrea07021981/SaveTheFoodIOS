//
//  LoginTest.swift
//  SaveTheFoodTests
//
//  Created by Andrea Franco on 2020-09-07.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import XCTest
@testable import SaveTheFood

class LoginTest: XCTestCase {
    
    private var userManager: UserManeger?
    private var userManagerDelegate: MockUserDelegate?
    
    override func setUp() {
        userManager = UserManeger()
        userManagerDelegate = MockUserDelegate()
        userManager?.delegate = userManagerDelegate
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }
    
    func test_login_successful() {
        userManager?.doLoginWithEmailPass(email: "a@a.com", pass: "aaaaa")
        
        XCTAssertTrue(((userManagerDelegate?.isUserIsAuthenticated) != nil && (userManagerDelegate?.isUserIsAuthenticated == false)))
    }
}
