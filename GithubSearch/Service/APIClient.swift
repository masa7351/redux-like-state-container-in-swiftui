//
//  APIClient.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2020/02/16.
//  Copyright © 2020 Majid Jabrayilov. All rights reserved.
//

import Combine
import Foundation

final class APIClient {
    let baseURL = "https://api.github.com/search"
    let transport: Transport

    init(transport: Transport = URLSession.shared) { self.transport = transport }

    func fetch<Model>(_: Model.Type, queries: [URLQueryItem]) -> AnyPublisher<[Model.Response], Error> where Model: Fetchable {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(Model.apiBase)") else {
            preconditionFailure("Can't create url components...")
        }
        if !queries.isEmpty {
            urlComponents.queryItems = queries
        }
        guard let url = urlComponents.url else { preconditionFailure("Cant't create url from url components...") }

        return transport.fetch(for: url)
            .decode(type: Model.self, decoder: JSONDecoder())
            .map { $0.items }
            .eraseToAnyPublisher()
    }
}

protocol Fetchable: Decodable {
    associatedtype Response
    static var apiBase: String { get }
    var items: [Response] { get set }
}

protocol Transport {
    func fetch(for url: URL) -> AnyPublisher<Data, URLError>
}

extension URLSession: Transport {
    func fetch(for url: URL) -> AnyPublisher<Data, URLError> {
        dataTaskPublisher(for: url).map { $0.data }.eraseToAnyPublisher()
    }
}

