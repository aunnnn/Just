//
//  Just.swift
//  Just
//
//  Created by Wirawit Rueopas.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import Foundation

/// Just request.
public struct Just {
    
    public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request {
        return Request(url: url, method: method, parameters: parameters, headers: headers, configurationBlock: configurationBlock)
    }
    
    /// Make `GET` request. Return nil if the urlString is invalid.
    public static func get(_ urlString: String, queries: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request? {
        guard let url = URL(string: urlString) else { return nil }
        return Request(url: url, method: .get, parameters: queries, headers: headers, configurationBlock: configurationBlock)
    }
    
    /// Make `POST` request. Return nil if the urlString is invalid.
    public static func post(_ urlString: String, jsonBody: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request? {
        guard let url = URL(string: urlString) else { return nil }
        return Request(url: url, method: .post, parameters: jsonBody, headers: headers, configurationBlock: configurationBlock)
    }
}
