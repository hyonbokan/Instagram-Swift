//
//  InstagramTests.swift
//  InstagramTests
//
//  Created by dnlab on 2023/10/04.
//
@testable import Instagram

import XCTest

final class InstagramTests: XCTestCase {
    
    func testNotificationIDCreation() {
        let first = NotificationManager.newIdentifier()
        let secord = NotificationManager.newIdentifier()
        XCTAssertNotEqual(first, secord)
    }
    
    func testNotificationIDCreationFail() {
        let first = NotificationManager.newIdentifier()
        let secord = NotificationManager.newIdentifier()
        XCTAssertEqual(first, secord)
    }
}
