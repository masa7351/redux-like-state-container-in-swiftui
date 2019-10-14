//
//  SearchUserService.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

struct User: Hashable, Identifiable, Decodable {
    var id: Int64
    var login: String
    var avatar_url: URL
}

struct UserResponse: Decodable {
    let items: [User]
}

class SearchUserService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func searchPublisher(matching query: String) -> AnyPublisher<[User], Error> {
        guard
            var urlComponents = URLComponents(string: "https://api.github.com/search/users")
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
            .decode(type: UserResponse.self, decoder: decoder)
            .map { $0.items }
            .eraseToAnyPublisher()
    }
}
