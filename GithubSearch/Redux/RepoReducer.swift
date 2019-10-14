//
//  Repo.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

// MARK: - Action

enum RepoMutation {
    case searchResults(repos: [Repo])
}

enum RepoAction: Action {
    case fetchList(query: String)
    
    func mapToMutation() -> AnyPublisher<RepoMutation, Never> {
        switch self {
        case let .fetchList(query):
            return dependencies.repoService
                .searchPublisher(matching: query)
                .replaceError(with: [])
                .map { RepoMutation.searchResults(repos: $0) }
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - State

struct RepoState {
    fileprivate(set) var searchResult: [Repo] = []
}

let repoReducer: Reducer<RepoState, RepoMutation> = { state, mutation in
    switch mutation {
    case let .searchResults(repos):
        state.searchResult = repos
    }
}
