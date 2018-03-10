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

func examples() {
    Just.request(myRepo, method: .get)?.response({ (result) in
        switch result {
        case .success(let data):
            print(data.count)
        case .error(let error):
            print(error.localizedDescription)
        }
    })
    
    Just.request(myRepo, method: .get)?.responseObject({ (result: Result<[Repo]>) in
        switch result {
        case let .success(repos):
            repos[0..<4].forEach({ (r) in
                print(r)
            })
        case let .error(error):
            print(error)
        }
    })
}

examples()

PlaygroundPage.current.needsIndefiniteExecution = true
