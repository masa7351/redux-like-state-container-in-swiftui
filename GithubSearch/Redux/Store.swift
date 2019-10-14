//
//  Redux.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 9/16/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import Foundation
import Combine

protocol Action {
    associatedtype Mutation
    // Change from Action to Dispatch Availability Action.
    func mapToMutation() -> AnyPublisher<Mutation, Never>
}

typealias Reducer<State, Mutation> = (inout State, Mutation) -> Void

final class Store<AppState, AppAction: Action>: ObservableObject {
    // point: read only
    @Published private(set) var state: AppState
    // Generally, reducer or composition of reducers is the single place where your app mutates the state.
    private let appReducer: Reducer<AppState, AppAction.Mutation>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialState: AppState,
        appReducer: @escaping Reducer<AppState, AppAction.Mutation>
    ) {
        self.state = initialState
        self.appReducer = appReducer
    }

    // SwiftUI gives us @EnvironmentObject
    // @EnvironmentObject is set a ancestor view by SceneDelegate.
    // A state is unique for your app.
    // You don't need pass state for reduce method.
    //
    // general Reducer
    //  (in) dispatched action + state -> (out) new State
    func reduce(_ action: AppAction) {
        action
            // change to Dispatch Availability Action.
            .mapToMutation()
            .receive(on: DispatchQueue.main)
            // dispatch
            .sink { self.appReducer(&self.state, $0) }
            .store(in: &cancellables)
    }
}
