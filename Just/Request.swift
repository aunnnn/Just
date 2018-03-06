public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]
public typealias URLRequestConfigurationBlock = (URLRequest) -> URLRequest

public enum POSTBodyEncoding {
    case json
    case url
}

/// Only GET or POST
public enum HTTPMethod {
    
    case get
    case post(POSTBodyEncoding)
    
    public var string: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

public enum Result<T> {
    case success(T)
    case error(Error)
}

/// A URLRequest wrapper
public struct Request {
    
    public let url: URL
    
    public let method: HTTPMethod
    
    public let parameters: Parameters?
    
    public let headers: HTTPHeaders?
    
    /// A configuration block for generated URLRequest. You can modify the request or return different one completely.
    public var configurationBlock: URLRequestConfigurationBlock?
    
    private func percentEscapeString(string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    public func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        if let params = parameters {
            switch method {
            case .post(let encoding):
                switch encoding {
                case .json:
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                case .url:
                    request.httpBody = params.map { (tuple) -> String in
                        return "\(tuple.key)=\(self.percentEscapeString(string: "\(tuple.value)"))"
                        }.joined(separator: "&").data(using: .utf8, allowLossyConversion: true)
                    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
                request.addValue("application/json", forHTTPHeaderField: "Accept")
            case .get:
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                components.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                let urlWithQueries = components.url!
                request = URLRequest(url: urlWithQueries)
            }
        }
        request.httpMethod = method.string
        request.allHTTPHeaderFields = headers
        if let configured = configurationBlock {
            return configured(request)
        } else {
            return request
        }
    }
    
    private func _response(_ completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.dataTask(with: self.asURLRequest()) { (data, response, error) in
            if let error = error {
                completion(.error(error))
            } else {
                if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    (200 ... 299) ~= response.statusCode {
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "com.aunwirawit.Just", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data found."])
                    completion(.error(error))
                }
            }
        }.resume()
    }
    
    /// Make the request immediately and return result on the main thread.
    public func response(_ completion: @escaping (Result<Data>) -> Void) {
        self._response { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    /// Make the request immediately, decode the model from JSON, and return result on the main thread.
    public func responseObject<T: Decodable>(_ completion: @escaping (Result<T>) -> Void) {
        self._response { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } catch (let error) {
                    DispatchQueue.main.async {
                    	completion(.error(error))
                    }
                }
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }
}
