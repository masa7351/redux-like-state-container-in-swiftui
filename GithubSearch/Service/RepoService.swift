//
//  RepoService.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 6/5/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

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

struct RepoResponse: Decodable {
    let items: [Repo]
}

class RepoService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func searchPublisher(matching query: String) -> AnyPublisher<[Repo], Error> {
        guard
            var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")
            else { preconditionFailure("Can't create url components...") }

        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }

        return session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RepoResponse.self, decoder: decoder)
            .map { $0.items }
            .eraseToAnyPublisher()
    }
}