//
//  App.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 9/16/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

// MARK: - Action

enum AppMutation {
    case search(mutation: RepoMutation)
    case user(mutation: UserMutation)
}

enum AppAction: Action {
    case search(action: RepoAction)
    case user(action: UserAction)

    func mapToMutation() -> AnyPublisher<AppMutation, Never> {
        switch self {
        case let .search(action):
            return action
            .mapToMutation()
            .map { AppMutation.search(mutation: $0) }
            .eraseToAnyPublisher()
        case let .user(action):
            return action
            .mapToMutation()
            .map { AppMutation.user(mutation: $0) }
            .eraseToAnyPublisher()
        }
    }
}

// MARK: - State

struct AppState {
    fileprivate(set) var repoState: RepoState
    fileprivate(set) var userState: UserState
}

let appReducer: Reducer<AppState, AppMutation> = { state, mutation in
    switch mutation {
    case let .search(mutation):
        repoReducer(&state.repoState, mutation)
    case let .user(mutation):
        userReducer(&state.userState, mutation)
    }
}
