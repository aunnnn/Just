//
//  JustRequestTests.swift
//  JustTests
//
//  Created by Wirawit Rueopas on 28/4/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import XCTest
@testable import Just

class JustRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testMakeGETRequest() {
        let url = URL(string: "www.google.com")!
        let request = Just.request(url, method: .get).asURLRequest()
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
        XCTAssertNil(request.httpBody)
    }
    
}
