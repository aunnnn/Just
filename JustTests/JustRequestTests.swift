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
        XCTAssertEqual(request.allHTTPHeaderFields, ["Accept": "application/json"])
        XCTAssertNil(request.httpBody)
    }

    func testMakeGETRequestWithParametersAndHeaders() {
        let url = URL(string: "www.google.com")!
        let headers = ["header1": "1", "header2": "2"]
        let request = Just.request(url, method: .get, parameters: ["param1": 5, "param2": "hello"], headers: headers, configurationBlock: nil).asURLRequest()

        XCTAssertEqual(request.url, URL(string: "www.google.com?param1=5&param2=hello")!)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields, ["Accept": "application/json",
                                                     "header1": "1",
                                                     "header2": "2"])
        XCTAssertNil(request.httpBody)
    }

    func testMakePOSTRequestTypeJSON() {
        let url = URL(string: "www.google.com")!
        let request = Just.request(url, method: .post(.json)).asURLRequest()

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                     "Accept": "application/json"])
        XCTAssertNil(request.httpBody)
    }

    func testMakePOSTRequestTypeURLEncoded() {
        let url = URL(string: "www.google.com")!
        let request = Just.request(url, method: .post(.url)).asURLRequest()

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/x-www-form-urlencoded",
                                                     "Accept": "application/json"])
        XCTAssertNil(request.httpBody)
    }

    func testMakePOSTRequestTypeJSONWithParametersAndHeaders() {
        let url = URL(string: "www.google.com")!
        let p: Parameters = ["body1": "1"]
        let h: HTTPHeaders = ["header1": "1"]
        let request = Just.request(url, method: .post(.json), parameters: p, headers: h, configurationBlock: nil).asURLRequest()

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                     "Accept": "application/json",
                                                     "header1": "1"])

        let jsonBody = try! JSONSerialization.data(withJSONObject: p)
        XCTAssertEqual(request.httpBody, jsonBody)
    }

    func testMakePOSTRequestTypeURLEncodedWithParametersAndHeaders() {
        let url = URL(string: "www.google.com")!
        let p: Parameters = ["body1": "1", "body2": "2"]
        let h: HTTPHeaders = ["header1": "1"]
        let request = Just.request(url, method: .post(.url), parameters: p, headers: h, configurationBlock: nil).asURLRequest()

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/x-www-form-urlencoded",
                                                     "Accept": "application/json",
                                                     "header1": "1"])

        // Make order of params irrelevant
        let targetBody = "body1=1&body2=2".split(separator: "&").sorted()
        let actualBody = String(data: request.httpBody!, encoding: .utf8)!.split(separator: "&").sorted()
        XCTAssertEqual(actualBody, targetBody)
    }
}
