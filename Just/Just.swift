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
    
    /// Make a request. Note that `method` supports only `.get` and `.post(POSTBodyEncoding)`, where POSTBodyEncoding is either `url` or `json`
    public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request {
        return Request(url: url, method: method, parameters: parameters, headers: headers, configurationBlock: configurationBlock)
    }
    
    /// Make a request. Note that `method` supports only `.get` and `.post(POSTBodyEncoding)`, where POSTBodyEncoding is either `url` or `json`
    public static func request(_ urlString: String, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request? {
        guard let url = URL(string: urlString) else { return nil }
        return Request(url: url, method: method, parameters: parameters, headers: headers, configurationBlock: configurationBlock)
    }
}
