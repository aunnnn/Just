# Just
A URLSession wrapper just for GET and POST of JSON.

## Features
- [x] Under 150 lines of code.
- [x] GET
- [x] POST
- [x] Decode JSON to `T` using the new `Codable` ✨

## Installation
### CocoaPods
```ruby
pod 'Just', :git => 'https://github.com/aunnnn/Just.git'
```
*Note: `:git => 'https://github.com/aunnnn/Just.git'` is to prevent clashing names with other pods.*
### Manual
Pick the code to your project.

## Requirements
iOS 8+, OSX 10.10+, Swift 4

## Usage
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
Just.get("https://api.github.com/users/aunnnn/repos")?.responseObject({ (result: Result<[Repo]>) in
    switch result {
    case let .success(repos):
        print(repos)
    case let .error(error):
        print(error)
    }
})
```

**Now you get the pattern.**

### 2. POST
```swift
Just.post(url, jsonBody: ["foo": "bar"])
```
### 3. Either GET or POST
Just use `method`:
```swift
Just.request(url, method: .get)
```

### Full interface 
```swift
public static func request(_ url: URL, method: HTTPMethod, parameters: Parameters?=nil, headers: HTTPHeaders?=nil) -> Request
```

### A suggested way to work with APIs
Make the base protocol for API service that you can build Just.Request from: 
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
    var request: Request {
        let url = baseURL.appendingPathComponent(path)
        return Just.request(url, method: method, parameters: parameters, headers: headers)
    }
}
```
Then make an enum for each service in your app that conforms to `APIService`, e.g.,:
```swift
enum GithubAPI: APIService {
    case getUser(...)
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
    
    ...you get the idea
}
```

Now it's easy to call API:
```swift
GithubAPI.getUser(...).request.responseObject{  (result: Result<[User]>) in
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

*Note: I'm doing `RequestType` protocol, so you can control how you create URLRequest, which'll give us a litle more control.*

### Is this related to [JustHTTP](https://github.com/JustHTTP/Just)?
Totally unrelated. Actually, I found them out the moment I finish coding this. A library with the same name doing almost the same thing! Still, checking the docs and you will notice quickly that our goals are very different.
