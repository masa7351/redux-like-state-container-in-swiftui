//
//  DetailView.swift
//  GithubSearch
//
//  Created by Masanao Imai on 2019/10/14.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var repo: Repo
    private var description: String {
        return repo.description ?? ""
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !description.isEmpty {
                HStack {
                    Text("description:").font(.title)
                    Spacer()
                }
                HStack {
                    Text(description)
                        .lineLimit(Int.max)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
            HStack {
                Text("star: \(repo.stargazersCount)")
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(repo.name), displayMode: .inline)
    }
}
