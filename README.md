# Just
[![Version](https://img.shields.io/cocoapods/v/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)
[![License](https://img.shields.io/cocoapods/l/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)
[![Platform](https://img.shields.io/cocoapods/p/JustRequest.svg?style=flat)](http://cocoapods.org/pods/JustRequest)

A lightweight URLSession wrapper just for GET and POST.

## Features
- [x] < 150 lines of code.
- [x] GET
- [x] POST (json or urlencoded)
- [x] Decode JSON response to `T` using the new `Codable` ✨

## Installation
### CocoaPods
```ruby
pod 'JustRequest'
```

### Manual
Pick the code to your project.

## Requirements
iOS 8+, OSX 10.10+, Swift 4

## Usage
`Just` provides only 3 interfaces for you:
### 1. GET
```swift
Just.get("https://api.github.com/users/aunnnn/repos")?.response { (result) in
    switch result {
    case let .success(data):
        print(data) // Data
    case let .error(error):
        print(error)
    }
}
```

If you also want to convert response to JSON:
```swift
Just.get("https://api.github.com/users/aunnnn/repos")?.responseObject { (result: Result<[Repo]>) in
    switch result {
    case let .success(repos):
        print(repos)
    case let .error(error):
        print(error)
    }
}
```

**Now you get the pattern.**

### 2. POST
`encoding` is either `.url` or `.json`:
```swift
Just.post("your url string", body: ["foo": "bar"], encoding: .url)
```

### 3. Full Interface
```swift
public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil, configurationBlock: URLRequestConfigurationBlock?=nil) -> Request
```

### To configure the default URLRequest
Provide URLRequest configuration block:
```swift
Just.get("https://api.github.com/users/aunnnn/repos", configurationBlock: { (request: URLRequest) -> URLRequest in
    var newReq = request
    newReq.cachePolicy = .returnCacheDataElseLoad
    return newReq
})
```

## A suggested way to work with APIs
You can use `Just.get` or `Just.post`, but the recommended way is to wrap an API with enum and use `Just.request.`

First, make a base protocol for API service: 
```swift
import Just

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
            return .post
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

## Contribution
Pull requests are welcomed!

## FAQ
### Is this for me?
`Just` is very limited. If you need a finer-grain control over how to make request, cache policy, etc., you should just use other libraries. Also, check the code (common, just 150 lines) if it's what you need.

### Is this related to [JustHTTP](https://github.com/JustHTTP/Just)?
Totally unrelated. Actually, I found them out the moment I finish coding this. A library with the same name doing almost the same thing! Still, checking the docs and you will notice quickly that our goals are very different.
