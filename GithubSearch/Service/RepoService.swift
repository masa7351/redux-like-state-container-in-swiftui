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

final class RepoServiceImpl: RepoService {
    private let apiClient: APIClient
    init(transport: Transport = URLSession.shared) {
        apiClient = APIClient(transport: transport)
    }

    func searchPublisher(matching query: String) -> AnyPublisher<[Repo], Error> {
        apiClient.fetch(RepoResponse.self, queries: [URLQueryItem(name: "q", value: query)])
    }
}

// MARK: - Test

final class TestRepoTransport: Transport {
    func fetch(for url: URL) -> AnyPublisher<Data, URLError> {
        let data = loadRawData("repositories.json")
        return Future<Data, URLError> { callback in
            callback(.success(data))
        }
        .eraseToAnyPublisher()
    }
}
