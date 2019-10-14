//
//  UserImage.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import SwiftUI
import Combine

// original code is
// https://github.com/ra1028/SwiftUI-Combine
class UserImageFetcher: ObservableObject {
    @Published private(set) var userImages = [User: UIImage]()

    func fetchImage(for user: User) {
        guard case .none = userImages[user] else {
            // Skip if this fetcher already has it as cache
            print("I have already cache this image.")
            return
        }

        let request = URLRequest(url: user.avatar_url)
        _ = URLSession.shared.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] image in
                self?.userImages[user] = image
            })
    }

}
