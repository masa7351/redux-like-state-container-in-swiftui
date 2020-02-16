//
//  User.swift
//  GithubSearch
//
//  Created by 今井真尚 on 2019/10/16.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import Foundation

struct User: Hashable, Identifiable, Decodable {
    var id: Int64
    var login: String
    var avatar_url: URL
}

struct UserResponse: Fetchable {
    var items: [User]
    static var apiBase: String { "/users" }
}

