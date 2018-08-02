//
//  Media.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Infinum Student Academy MG. All rights reserved.
//

import Foundation

struct Media: Codable { /* typealias Codable = Encodable & Decodable */
//    let showId: String?
    let mediaId: String?
//    let title: String
//    let description: String
//    let episodeNumber: String
//    let season: String
    
    enum CodingKeys: String, CodingKey {
//        case showId
        case mediaId
//        case title
//        case description
//        case episodeNumber
//        case season
    }
}
