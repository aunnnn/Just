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

## Contribution
Pull requests are welcomed!

## FAQ
### Is this for me?
`Just` is very limited. If you need a finer-grain control over how to make request, cache policy, etc., you should just use other libraries. Also, check the code (common, just 150 lines) if it's what you need.

*Note: I'm doing `RequestType` protocol, so you can control how you create URLRequest, which'll give us a litle more control.*

### Is this related to JustHTTP?
[JustHTTP](https://github.com/JustHTTP/Just)
No. Actually, I found out there's a library with the same name that does almost the same thing the moment I finish coding this! Checking the docs and you will notice quickly that our goals are very different.
