//
//  Just.swift
//  Just
//
//  Created by Wirawit Rueopas.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import Foundation

/// Just GET (query string) and POST (json body).
public struct Just {
    public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil) -> Request {
        return Request(url: url, method: method, parameters: parameters, headers: headers)
    }
    
    public static func get(_ url: URL, queries: Parameters?=nil, headers: HTTPHeaders?=nil) -> Request {
        return Request(url: url, method: .get, parameters: queries, headers: headers)
    }
    
    public static func post(_ url: URL, jsonBody: Parameters?=nil, headers: HTTPHeaders?=nil) -> Request {
        return Request(url: url, method: .post, parameters: jsonBody, headers: headers)
    }
    
    public static func request(_ urlString: String, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil) ->Request? {
        guard let url = URL(string: urlString) else { return nil }
        return Request(url: url, method: method, parameters: parameters, headers: headers)
    }
    
    public static func get(_ urlString: String, queries: Parameters?=nil, headers: HTTPHeaders?=nil) -> Request? {
        guard let url = URL(string: urlString) else { return nil }
        return Request(url: url, method: .get, parameters: queries, headers: headers)
    }
    
    public static func post(_ urlString: String, jsonBody: Parameters?=nil, headers: HTTPHeaders?=nil) -> Request? {
        guard let url = URL(string: urlString) else { return nil }
        return Request(url: url, method: .post, parameters: jsonBody, headers: headers)
    }
}
