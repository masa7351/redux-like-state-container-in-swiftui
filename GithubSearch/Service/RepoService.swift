//
//  RepoService.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 6/5/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

protocol RepoService {
    func searchPublisher(matching query: String) -> AnyPublisher<[Repo], Error>
}

class RepoServiceImpl : RepoService {
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
