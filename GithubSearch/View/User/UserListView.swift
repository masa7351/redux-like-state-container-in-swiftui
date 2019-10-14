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
    // NOTE: This is not the correct Redux architecture.
    @ObservedObject var userImageFetcher = UserImageFetcher()
    @State private var query: String = "Apple"

    var body: some View {
        UserSearchView(
            query: $query,
            userImageFetcher: userImageFetcher,
            users: store.state.userState.searchResult,
            onCommit: fetchUser
        ).onAppear(perform: fetchUser)

    }

    private func fetchUser() {
        store.send(.user(action: .fetchList(query: query)))
    }
}

// MARK: - Reducerやライフサイクルを仕組みを意識しないPureなレイアウト部分


private struct UserSearchView : View {
    @Binding var query: String
    @ObservedObject var userImageFetcher: UserImageFetcher
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
                        UserRow(user: user, userImageFetcher: self.userImageFetcher)
                            .onAppear { self.userImageFetcher.fetchImage(for: user) }
                    }
                }
            }.navigationBarTitle(Text("User List"))
        }
    }
}

struct UserRow: View {
    let user: User
    @ObservedObject var userImageFetcher: UserImageFetcher
    var body: some View {
        HStack {
            userImageFetcher.userImages[user].map { image in
                Image(uiImage: image)
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            Text(user.login)
                .font(Font.system(size: 18).bold())
            Spacer()
        }
        .frame(height: 60)
    }
}
