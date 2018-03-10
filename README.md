# Just
[![Version](https://img.shields.io/cocoapods/v/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)
[![License](https://img.shields.io/cocoapods/l/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)
[![Platform](https://img.shields.io/cocoapods/p/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)

A lightweight URLSession wrapper just for GET and POST, because that's all we care about.

## Features
- [x] Lightweight, < 150 lines of code
- [x] GET
- [x] POST (json or urlencoded)
- [x] Decode JSON response to `T` using the new `Codable` ✨

## Installation
### CocoaPods
```ruby
pod 'JustRequest'
```

### Manual
Just download the code.

## Requirements
iOS 8+, OSX 10.10+, Swift 4

## Usage
### 1. request with `url`
```swift
public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request
```

### 2. request with `urlString`
```swift
public static func request(_ urlString: String, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request
```
*Note: The second one will get deprecated in the future, as it's quite trivial to convert to `URL` yourself.*

### To configure the default URLRequest
Provide URLRequest configuration block:
```swift
Just.request("https://api.github.com/users/aunnnn/repos", method: .get, configurationBlock: { (request: URLRequest) -> URLRequest in
    var newReq = request
    newReq.cachePolicy = .returnCacheDataElseLoad
    return newReq
})
```

## A suggested way to work with APIs
Organize a set of API with enum and use `Just.request`:

First, make a base protocol for API service: 
```swift
import JustRequest

public protocol APIService {
    var baseURL: URL { get }
    var method: HTTPMethod  { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension APIService {

    /// Build `Request` for corresponding API.
    var request: Request {
        let url = baseURL.appendingPathComponent(path)
        return Just.request(url, method: method, parameters: parameters, headers: headers)
    }
}
```
Then, make an enum for each service in your app that conforms to `APIService`:
```swift
enum GithubAPI: APIService {
    case getUser(id: String)
    case getRepos(...)
    case deleteRepo(...)
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser, .getRepo: 
            return .get
        case .deleteRepo: 
            return .post(.json)
        }
    }
    
    var parameters: [String: Any]? { ...
    
    ...you get the idea
}
```

To use:
```swift
GithubAPI.getUser(id: "123").request.responseObject{  (result: Result<[User]>) in
   switch result {
   case .success(let users): print(users)
   case .error(let error): print(error)
   }
}
```

*Note: It's important to explicitly specify `result: Result<[User]>` to help the compiler knows the model you are dealing with. With this, you can interact with `users` as `[User]`.*

## Motivation
Most apps use only interact with JSON API via simple `GET` and `POST`, so `Alamofire` can be an overkill. This URLSession wrapper should be enough.

## Contribution
Pull requests are welcomed!

## FAQ
### Is this for me?
`Just` is very limited. If you need a finer-grain control over how to make request, cache policy, etc., you should just use other libraries. Also, check the code if it's what you need.

I suggest you to fork this and do whatever you want with it.

### Is this related to [JustHTTP](https://github.com/JustHTTP/Just)?
Totally unrelated. Actually, I found them out the moment I finish coding this. A library with the same name doing almost the same thing! Still, checking the docs and you will notice quickly that our goals are very different.
