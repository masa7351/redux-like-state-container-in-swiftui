//
//  RepoServiceMock.swift
//  GithubSearch
//
//  Created by 今井真尚 on 2019/10/17.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation
import Combine

final class RepoServiceMock: RepoService {
    
    func searchPublisher(matching query: String) -> AnyPublisher<[Repo], Error> {
        print("fetch repo list")
        let data = repoData.items
        if data.isEmpty {
            let error = FetchError.parsing(description: "Couldn't load data")
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Future<[Repo], Error> { promise in
                return promise(.success(data))
            }.eraseToAnyPublisher()
        }
    }
}

class SearchUserServiceMock : SearchUserService {
    func searchPublisher(matching query: String) -> AnyPublisher<[User], Error> {
        print("fetch user list")
        let data = userData.items
        if data.isEmpty {
            let error = FetchError.parsing(description: "Couldn't load data")
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Future<[User], Error> { promise in
                return promise(.success(data))
            }.eraseToAnyPublisher()
        }
    }
}
enum FetchError: Error {
  case parsing(description: String)
}
