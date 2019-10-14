//
//  App.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 9/16/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

//enum AppMutation {
//    case searchResults(repos: [Repo])
//}

enum AppMutation {
    case search(mutation: SearchMutation)
}

enum SearchMutation {
    case searchResults(repos: [Repo])
}

//enum AppAction: Action {
//    case search(query: String)
//
//    func mapToMutation() -> AnyPublisher<AppMutation, Never> {
//        switch self {
//        case let .search(query):
//            return dependencies.githubService
//                .searchPublisher(matching: query)
//                .replaceError(with: [])
//                .map { AppMutation.searchResults(repos: $0) }
//                .eraseToAnyPublisher()
//        }
//    }
//}

enum SearchAction: Action {
    case search(query: String)
    
    func mapToMutation() -> AnyPublisher<SearchMutation, Never> {
        switch self {
        case let .search(query):
            return dependencies.githubService
                .searchPublisher(matching: query)
                .replaceError(with: [])
                .map { SearchMutation.searchResults(repos: $0) }
                .eraseToAnyPublisher()
        }
    }

}

enum AppAction: Action {
    case search(action: SearchAction)

    func mapToMutation() -> AnyPublisher<AppMutation, Never> {
        switch self {
        case let .search(action):
            return action
            .mapToMutation()
            .map { AppMutation.search(mutation: $0) }
            .eraseToAnyPublisher()
        }
    }
}

struct AppState {
//    var searchResult: [Repo] = []
    var searchState: SearchState
}

// add
struct SearchState {
    var searchResult: [Repo] = []
}

//let appReducer: Reducer<AppState, AppMutation> = { state, mutation in
//    switch mutation {
//    case let .searchResults(repos):
//        state.searchResult = repos
//    }
//}


let appReducer: Reducer<AppState, AppMutation> = { state, mutation in
    switch mutation {
    case let .search(mutation):
        searchReducer(&state.searchState, mutation)
    }
}


let searchReducer: Reducer<SearchState, SearchMutation> = { state, mutation in
    switch mutation {
    case let .searchResults(repos):
        state.searchResult = repos
    }
}
