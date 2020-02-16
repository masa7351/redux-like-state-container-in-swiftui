//
//  SearchUserService.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Combine
import Foundation

protocol SearchUserService {
    func searchPublisher(matching query: String) -> AnyPublisher<[User], Error>
}

final class SearchUserServiceImpl: SearchUserService {
    private let apiClient: APIClient
    init(transport: Transport = URLSession.shared) {
        apiClient = APIClient(transport: transport)
    }

    func searchPublisher(matching query: String) -> AnyPublisher<[User], Error> {
        apiClient.fetch(UserResponse.self, queries: [URLQueryItem(name: "q", value: query)])
    }
}

// MARK: - Test

final class TestUserTransport: Transport {
    func fetch(for url: URL) -> AnyPublisher<Data, URLError> {
        let data = loadRawData("user.json")
        return Future<Data, URLError> { callback in
            callback(.success(data))
        }
        .eraseToAnyPublisher()
    }
}
