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
    case searchResults(users: [User], error: Error?)
}

enum UserAction: Action {
    case fetchList(query: String)
    
    func mapToMutation(dependencies: Dependencies) -> AnyPublisher<UserMutation, Never> {
        switch self {
        case let .fetchList(query):
            return dependencies.searchUserService
                .searchPublisher(matching: query)
                .map { UserMutation.searchResults(users: $0, error: nil) }
                .catch { Just(UserMutation.searchResults(users: [], error: $0)) } // handle error
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - State

struct UserState {
    fileprivate(set) var searchResult: [User] = []
    fileprivate(set) var errorMessage: String = ""
}

// MARK: - Reducer

let userReducer: Reducer<UserState, UserMutation> = { state, mutation in
    switch mutation {
    case let .searchResults(_, error) where error != nil:
        state = UserState(searchResult: state.searchResult, errorMessage: "It occured a some error.")
    case let .searchResults(users, _):
        state = UserState(searchResult: users, errorMessage: "")
    }
}
