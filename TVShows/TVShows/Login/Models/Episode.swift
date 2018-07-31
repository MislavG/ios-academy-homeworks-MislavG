//
//  Episode.swift
//  TVShows
//
//  Created by Infinum Student Academy on 29/07/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import Foundation

//{"_id":"3VLHzWF4MJUSH2GE","title":"","description":"","imageUrl":"","episodeNumber":"","season":""}

struct Episode: Codable { /* typealias Codable = Encodable & Decodable */
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}
