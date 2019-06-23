//
//  File.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

let users = [
    user(userName: "sarahshif", profileImage: "sarahprofilepic", userId: 3),
    user(userName: "kevin", profileImage: "kevinprofilepic", userId: 1),
    user(userName: "mariar", profileImage: "mariaprofilepic", userId: 4)
]

struct user {
    var userName: String
    var profileImage: String
    var userId: Int
}
