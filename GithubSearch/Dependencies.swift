//
//  Dependencies.swift
//  GithubSearch
//
//  Created by Majid Jabrayilov on 9/16/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation

struct Dependencies {
    var repoService: RepoService
    var searchUserService: SearchUserService
}

let fetchApi = Dependencies(repoService: RepoServiceImpl(),
                            searchUserService: SearchUserServiceImpl())

let fetchMock = Dependencies(repoService: RepoServiceMock(),
                             searchUserService: SearchUserServiceMock())
