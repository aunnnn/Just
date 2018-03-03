
import Foundation

/// Queries (GET) or JSON Body (POST)
public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

/// Only GET or POST
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Result<T> {
    case success(T)
    case error(Error)
}

/// A URLRequest wrapper
public struct Request {
    
    public let url: URL
    
    public let method: HTTPMethod
    
    /// In case of `GET`, it's a query in url. In case of `POST`, it's a JSON body.
    public let parameters: Parameters?
    
    public let headers: HTTPHeaders?
    
    public func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        if let params = parameters {
            switch method {
            case .post:
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
            case .get:
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                components.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                let urlWithQueries = components.url!
                request = URLRequest(url: urlWithQueries)
            }
        }
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
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
