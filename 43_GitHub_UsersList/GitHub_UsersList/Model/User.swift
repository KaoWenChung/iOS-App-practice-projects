//
//  User.swift
//  GitHub_UsersList
//
//  Created by wyn on 2020/6/29.
//  Copyright © 2020 Wyn. All rights reserved.
//

import Foundation

struct User: Decodable {
    let name : String?
    let image: String?
    let badge: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case name  = "login"
        case image = "avatar_url"
        case badge = "site_admin"
    }
}
