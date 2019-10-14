//
//  ContentView.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var query: String = "Swift"

    var body: some View {
        ResultListView(
            query: $query,
            repos: store.state.repoState.searchResult,
            users: store.state.userState.searchResult,
            onCommit: fetch
        ).onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(.search(action: .fetchList(query: query)))
        store.send(.user(action: .fetchList(query: query)))
    }
}

private struct ResultListView : View {
    @Binding var query: String
    let repos: [Repo]
    let users: [User]
    let onCommit: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer().frame(width: 10)
                    TextField("Type something", text: $query, onCommit: onCommit)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 10)
                        .background(Color.gray)
                        .clipShape(Capsule())
                    Spacer().frame(width: 10)
                }
                List {
                    repoList
                    userList
                }
            }.navigationBarTitle(Text("Search"), displayMode: .inline)
        }
    }
    
    var userList: some View {
        Section(header: Text("User")) {
            if users.isEmpty {
                Text("Loading...")
            } else {
                ForEach(users) { user in
                    UserRow(user: user)
                }
            }
        }
    }
    
    var repoList: some View {
        Section(header: Text("Repo")) {
            if repos.isEmpty {
                Text("Loading...")
            } else {
                ForEach(repos) { repo in
                    NavigationLink(destination: RepoDetailView(repo: repo)){
                        RepoRow(repo: repo)
                    }
                }
            }
        }
    }
}

