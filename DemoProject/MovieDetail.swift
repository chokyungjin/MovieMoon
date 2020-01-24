//
//  MovieDetail.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 22..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

//{
//    audience: 11676822,
//    grade: 12,
//    actor: "하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)",
//    duration: 139,
//    reservation_grade: 1,
//    title: "신과함께-죄와벌",
//    reservation_rate: 35.5,
//    user_rating: 7.98,
//    date: "2017-12-20",
//    director: "김용화",
//    id: "5a54c286e8a71d136fb5378e",
//    image: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movi
//    e_image.jpg",
//    synopsis: "저승 법에 의하면, (중략) 고난과 맞닥뜨리는데... 누구나 가지만 아무도 본 적 없는 곳, 새로
//    운 세계의 문이 열린다!", genre: "판타지, 드라마"
//}
struct MovieDetailApiResponse: Codable {
    
    typealias JSON = [String: AnyObject]
    
    let movie: MovieDetail
    
    init(json: Any) throws {
        guard
            let json = json as? JSON,
            let movie = MovieDetail(dict: json) else {
                
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                
                throw NetworkError.internetError
        }
        
        self.movie = movie
    }
}

struct MovieDetail: Codable {
    let audience: Int
    let grade: Int
    let actor: String
    let duration: Int
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let director: String
    let id: String
    let image: String
    let synopsis: String
    let genre: String

    init?(dict: [String: AnyObject]) {
        guard
            let audience = dict["audience"] as? Int,
            let grade = dict["grade"] as? Int,
            let actor = dict["actor"] as? String,
            let duration = dict["duration"] as? Int,
            let reservationGrade = dict["reservation_grade"] as? Int,
            let title = dict["title"] as? String,
            let reservationRate = dict["reservation_rate"] as? Double,
            let userRating = dict["user_rating"] as? Double,
            let date = dict["date"] as? String,
            let director = dict["director"] as? String,
            let id = dict["id"] as? String,
            let image = dict["image"] as? String,
            let synopsis = dict["synopsis"] as? String,
            let genre = dict["genre"] as? String else {
                
                return nil
        }
        
        self.audience = audience
        self.grade = grade
        self.actor = actor
        self.duration = duration
        self.reservationGrade = reservationGrade
        self.title = title
        self.reservationRate = reservationRate
        self.userRating = userRating
        self.date = date
        self.director = director
        self.id = id
        self.image = image
        self.synopsis = synopsis
        self.genre = genre
    }
}

enum NetworkError: Error {
    case internetError
}

let networkErrorNotificationName = Notification.Name("ErrorHandling")

