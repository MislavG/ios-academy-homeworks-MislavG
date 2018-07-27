//
//  User.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//


import Foundation

struct User: Codable { /* typealias Codable = Encodable & Decodable */
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}
