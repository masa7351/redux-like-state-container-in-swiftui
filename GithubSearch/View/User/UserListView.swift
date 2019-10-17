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
    @ObservedObject var imageFetcher = ImageFetcher()
    @State private var query: String = "Apple"

    var body: some View {
        UserSearchView(
            query: $query,
            imageFetcher: imageFetcher,
            users: store.state.userState.searchResult,
            onCommit: fetchUser
        ).onAppear(perform: fetchUser)

    }

    private func fetchUser() {
        store.dispatch(.user(action: .fetchList(query: query)))
    }
}

// MARK: - Reducerやライフサイクルを仕組みを意識しないPureなレイアウト部分

private struct UserSearchView : View {
    @Binding var query: String
    @ObservedObject var imageFetcher: ImageFetcher
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
                        UserRow(user: user, image: self.imageFetcher.images["\(user.id)"])
                            .onAppear { self.imageFetcher.fetch(key: "\(user.id)", path: user.avatar_url) }
                    }
                }
            }.navigationBarTitle(Text("User List"))
        }
    }
}

struct UserRow: View {
    let user: User
    let image: UIImage?
    var body: some View {
        HStack {
            // instead of "if let _image = image"
            image.map { _image in
                Image(uiImage: _image)
                    .resizable()
                    .frame(width: 60, height: 60)
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
