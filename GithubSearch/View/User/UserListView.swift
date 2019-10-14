//
//  UserListView.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var query: String = "Apple"

    var body: some View {
        UserSearchView(
            query: $query,
            users: store.state.userState.searchResult,
            onCommit: fetchUser
        ).onAppear(perform: fetchUser)

    }

    private func fetchUser() {
        store.send(.user(action: .fetchList(query: query)))
    }
}

// MARK: - Reducerやライフサイクルを仕組みを意識しないPureなレイアウト部分

struct UserRow: View {
    let user: User

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
            }
        }
    }
}


private struct UserSearchView : View {
    @Binding var query: String
    let users: [User]
    let onCommit: () -> Void

    var body: some View {
        NavigationView {
            List {
                TextField("Type something", text: $query, onCommit: onCommit)
                if users.isEmpty {
                    Text("Loading...")
                } else {
                    ForEach(users) { user in
                        UserRow(user: user)
                    }
                }
            }.navigationBarTitle(Text("User List"))
        }
    }
}
