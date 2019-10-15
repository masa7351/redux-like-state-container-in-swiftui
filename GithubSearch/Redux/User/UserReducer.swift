//
//  UserReducer.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

// MARK: - Action

enum UserMutation {
    case searchResults(users: [User])
}

enum UserAction: Action {
    case fetchList(query: String)
    
    func mapToMutation() -> AnyPublisher<UserMutation, Never> {
        switch self {
        case let .fetchList(query):
            return dependencies.searchUserService
                .searchPublisher(matching: query)
                .replaceError(with: [])
                .map { UserMutation.searchResults(users: $0) }
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - State

struct UserState {
    fileprivate(set) var searchResult: [User] = []
}

let userReducer: Reducer<UserState, UserMutation> = { state, mutation in
    switch mutation {
    case let .searchResults(users):
        state.searchResult = users
    }
}
