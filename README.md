# Just
A URLSession wrapper just for GET and POST of JSON.

## Features
- [x] Under 150 lines of code.
- [x] GET
- [x] POST
- [x] Decode JSON to `T` using the new `Codable` ✨

## Installation
### Cocoapods
```ruby
pod 'Just'
```
*Or just pick the code to your project directly.*

## Requirements
iOS 8+, OSX 10.10+, Swift 4

## Usage
1. GET:
```swift
Just.get()
```
2. POST:
```swift
Just.post()
```
3. Either GET or POST:
```swift
Just.request()
```
