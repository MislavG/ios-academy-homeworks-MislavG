//
//  Comment.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import Foundation

//{"text":"Ovo mi je skola","episodeId":"9dU0Vte9h9GTPNDb","userEmail":"jakov.vidak@gmail.com","_id":"In0aWXzbQ04HsFKg"}

struct Comment: Codable { /* typealias Codable = Encodable & Decodable */
    let text: String
    let episodeId: String
    let userMail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userMail
        case id = "_id"
    }
}
