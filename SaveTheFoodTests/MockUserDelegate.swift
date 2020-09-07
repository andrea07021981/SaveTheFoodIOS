//
//  MockUserDelegate.swift
//  SaveTheFoodTests
//
//  Created by Andrea Franco on 2020-09-07.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation
import Firebase
@testable import SaveTheFood

public class MockUserDelegate : UserManagerDelegate {
    public var isUserIsAuthenticated = false
    
    init() {
    }
    public func didRequestUser(_ userManager: UserManeger, user: AuthDataResult) {
        isUserIsAuthenticated = true
    }
    
    public func didFailWithError(error: String) {
        isUserIsAuthenticated = false
    }
    
    
}
