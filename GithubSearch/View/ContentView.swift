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
    // NOTE: This is not the correct Redux architecture.
    @ObservedObject private var imageFetcher = ImageFetcher()
    @State private var query: String = "Swift"
    var body: some View {
        ResultListView(
            query: $query,
            imageFetcher: imageFetcher,
            repos: store.state.repoState.searchResult,
            users: store.state.userState.searchResult,
            errorMessage: store.state.userState.errorMessage,
            onCommit: fetch
        ).onAppear(perform: fetch)
    }

    private func fetch() {
        store.dispatch(.search(action: .fetchList(query: query)))
        store.dispatch(.user(action: .fetchList(query: query)))
    }
}

private struct ResultListView : View {
    @Binding var query: String
    @ObservedObject var imageFetcher: ImageFetcher
    let repos: [Repo]
    let users: [User]
    let errorMessage: String
    let onCommit: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                }
                searchArea
                List {
                    userList
                    repoList
                }
            }
            .navigationBarTitle(Text("Search"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: { self.onCommit() },
                       label: { Image(systemName: "arrow.down") })
            )
        }
    }
    
    var searchArea: some View {
        HStack {
            Spacer().frame(width: 10)
            TextField("Type something", text: $query, onCommit: onCommit)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            Spacer().frame(width: 10)
        }.padding(.vertical, 10)
    }
    
    var userList: some View {
        Section(header: Text("User")) {
            if users.isEmpty {
                Text("Loading...")
            } else {
                ForEach(users) { user in
                    UserRow(user: user, image: self.imageFetcher.images["\(user.id)"])
                        .onAppear { self.imageFetcher.fetch(key: "\(user.id)", path: user.avatar_url) }
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

