//
//  Movie.swift
//  boxoffice
//
//  Created by Cho on 16/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import Foundation

struct ListResponse: Codable {
    let results: [Movie]
    let orderType: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "movies"
        case orderType = "order_type"
    }
}


struct Movie: Codable {
    let grade: Int
    let thumnailImageURL: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case grade, title, date, id
        case thumnailImageURL = "thumb"
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

