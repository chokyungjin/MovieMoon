//
//  MovieDetail.swift
//  boxoffice
//
//  Created by Cho on 16/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let posterImageURL: String
    let reservationGrade: Int
    let title: Int
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, title, date, id
        case posterImageURL = "image"
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
