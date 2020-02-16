//
//  Repo.swift
//  GithubSearch
//
//  Created by 今井真尚 on 2019/10/16.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation

struct Repo: Decodable, Identifiable {
    var id: Int
    let owner: Owner
    let name: String
    let stargazersCount: Int
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case stargazersCount = "stargazers_count"
        case description
    }
    
    struct Owner: Decodable {
        let avatar: URL

        enum CodingKeys: String, CodingKey {
            case avatar = "avatar_url"
        }
    }
}

struct RepoResponse: Fetchable {
    var items: [Repo]
    static var apiBase: String { "/repositories" }
}
