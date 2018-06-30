# Just
![Travis](https://travis-ci.org/aunnnn/Just.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)
[![License](https://img.shields.io/cocoapods/l/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)
[![Platform](https://img.shields.io/cocoapods/p/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)

A lightweight URLSession wrapper just for GET and POST, because that's all we really need.

## Features
- [x] Lightweight
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

`Just` only has one API:
```swift
public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request
```

*Don't forget to `import JustRequest`.*

### To actually fires a request
With these two APIs you will get a `Request` instance, but no request is fired yet. Like `Alamofire`, you can fire that request by calling `request.responseData { ... }` (or `request.responseObject { ... }` using `Decodable`.)

### To configure the default URLRequest
Provide URLRequest configuration block:
```swift
Just.request(URL(string: "https://api.github.com/users/aunnnn/repos")!, method: .get, configurationBlock: { (request: URLRequest) -> URLRequest in
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
Most apps use only interact with JSON API via simple `GET` and `POST`, so `Alamofire` can be an overkill. URLSession should be enough. "But I can't remember how to use `URLSession`!", then `Just` is for you.

## Contribution
Pull requests are welcomed! No tests yet...

## FAQ
### Is this for me?
`Just` is very limited. If you need a finer-grain control or performance optimization, you should use other libraries. This library is really for those who want to use simple `URLSession` but never remember how to use it. Please also note that there is no tests yet...

You could fork this and customize it to your needs.

### Is this related to [JustHTTP](https://github.com/JustHTTP/Just)?
Totally unrelated. Actually, I found them out the moment I finish coding this. A library with the same name doing almost the same thing! Still, checking the docs and you will notice quickly that our goals are very different.
