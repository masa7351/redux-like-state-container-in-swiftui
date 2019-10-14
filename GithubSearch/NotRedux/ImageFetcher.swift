//
//  ImageFetcher.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import SwiftUI
import Combine

// original code is
// https://github.com/ra1028/SwiftUI-Combine
class ImageFetcher: ObservableObject {
    @Published private(set) var images = [String: UIImage]()

    func fetch(key id: String, path: URL) {
        guard case .none = images[id] else {
            // Skip if this fetcher already has it as cache
            print("I have already cache this image.")
            return
        }

        let request = URLRequest(url: path)
        _ = URLSession.shared.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] image in
                self?.images[id] = image
            })
    }

}
