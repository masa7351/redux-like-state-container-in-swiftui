//
//  ContentView.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 6/4/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

// The main idea is dividing your views into two types: Container Views and Rendering Views. The Rendering View is responsible for drawing the content, and that’s all. So basically it should not store the state or handle lifecycle events. It usually renders the data which you pass via the init method.

// Container View, on another hand, is responsible for handling lifecycle events and providing the functions/closures to a Rendering View which it can use as user input handlers. Let’s take a look at a simple example.

// MARK: - ライフサイクルイベントやfunctions/closuresを提供する

struct SearchContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var query: String = "Swift"

    var body: some View {
//        SearchView(
//            query: $query,
//            repos: store.state.searchResult,
//            onCommit: fetch
//        ).onAppear(perform: fetch)
        SearchView(
            query: $query,
            repos: store.state.searchState.searchResult,
            onCommit: fetch
        ).onAppear(perform: fetch)

    }

    private func fetch() {
        store.send(.search(action: .fetchList(query: query)))
//        store.send(.fetchList(query: query))
    }
}

// MARK: - Reducerやライフサイクルを仕組みを意識しないPureなレイアウト部分

struct RepoRow: View {
    let repo: Repo

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(repo.name)
                    .font(.headline)
                Text(repo.description ?? "")
                    .font(.subheadline)
            }
        }
    }
}


struct SearchView : View {
    @Binding var query: String
    let repos: [Repo]
    let onCommit: () -> Void

    var body: some View {
        NavigationView {
            List {
                TextField("Type something", text: $query, onCommit: onCommit)

                if repos.isEmpty {
                    Text("Loading...")
                } else {
                    ForEach(repos) { repo in
                        RepoRow(repo: repo)
                    }
                }
            }.navigationBarTitle(Text("Search"))
        }
    }
}
