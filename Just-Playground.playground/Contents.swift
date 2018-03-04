//: Playground - noun: a place where people can play

import PlaygroundSupport
import Just

struct Repo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, name, owner, description
        case fullName = "full_name"
        case isPrivate = "private"
        case isFork = "fork"
        case htmlURL = "html_url"
    }
    
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    
    let isPrivate: Bool
    let isFork: Bool
    let htmlURL: URL
    
    let owner: Owner
}

struct Owner: Codable {
    
    enum CodingKeys: String, CodingKey {
        case login, id, url
        case isSiteAdmin = "site_admin"
    }
    
    let login: String
    let id: Int
    let url: URL
    let isSiteAdmin: Bool
}

let myRepo = "https://api.github.com/users/aunnnn/repos"

// GET Data
func get() {
    Just.get("http://www.google.com")?.response { (result) in
        switch result {
        case let .success(data):
            print(data.count)
        case let .error(error):
            print(error.localizedDescription)
        }
    }
}

// GET Model
func getModel() {
    Just.get(myRepo)?.responseObject({ (result: Result<[Repo]>) in
        switch result {
        case let .success(repos):
            repos[0..<10].forEach({ (r) in
                print(r)
            })
        case let .error(error):
            print(error)
        }
    })
}

func post() {
    let url = "http://mockbin.com/request"
    Just.post(url, jsonBody: ["foo": "bar"])?.response { (res) in
        switch res {
        case .success(let data):
            print(data.count)
        case .error(let error):
            print(error)
        }
    }
}

func configuration() {
    Just.get(myRepo, configurationBlock: { (request: URLRequest) -> URLRequest in
        var newReq = request
        newReq.cachePolicy = .returnCacheDataElseLoad
        return newReq
    })
}

get()

PlaygroundPage.current.needsIndefiniteExecution = true
