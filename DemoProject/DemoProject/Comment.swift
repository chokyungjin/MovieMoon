//
//  Comment.swift
//  boxoffice
//
//  Created by Cho on 17/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let rating: Double
    let timeStamp: Double
    let writer: String
    let id: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case timeStamp = "timestamp"
        case id = "movie_id"
    }
}
