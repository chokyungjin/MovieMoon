//
//  DiaryModel.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/12.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

struct DiaryModel: Codable {
    
    var id: Int
    var userId: String? = nil
    var movieId: String? = nil
    var memo: String
    var createDate: String
    var createdAt: String
    var updatedAt: String
    
}


//"poster": "http://file.koreafilm.or.kr/thm/02/00/00/95/tn_DPF000126.jpg",
//"createdAt": "2020-02-11T18:16:17.000Z",
//"updatedAt": "2020-02-11T18:16:17.000Z",
//"diaryId": 4,
//"movieId": 135,
//"userId": 7

struct DiaryGetList: Codable {
    
    var poster: String? = nil
    var userId : Int
    var diaryId : Int
    var movieId : Int
    var createdAt: String
    var updatedAt: String
    
    
}


// diary detail struct 만들어야 됨
//{
//    "id": 16,
//    "memo": "지금까지 이런 맛은 없었다. 이것은 갈비인가 통닭인가, 예 수원 왕갈비 통닭입니다!",
//    "createDate": "2020-12-13",
//    "createdAt": "2020-02-13T12:07:28.000Z",
//    "updatedAt": "2020-02-13T12:07:28.000Z",
//    "movieId": 8551,
//    "userId": 7,
//    "movie": {
//        "korTitle": "7공주 대리운전",
//        "makingNation": "대한민국",
//        "releaseDate": "20150528"
//    },
//    "diaryimages": []
//}

///http://54.180.186.62/api/diary/detail?diaryId=16
struct DiaryDetailModel: Codable {
    
    var id: Int
    var memo: String
    var createDate: String
    var createdAt: String
    var updatedAt: String
    var movieId : Int? = nil
    var userId : Int? = nil
    var movie: SearchTitleModel
    var diaryimages : [src]? = nil
    
}

struct src : Codable {
    var src: String? = nil
}


//
//  Movie.swift
//  boxoffice
//
//  Created by Cho on 16/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

//import Foundation
//
//struct ListResponse: Codable {
//    let results: [Movie]
//    let orderType: Int
//
//    enum CodingKeys: String, CodingKey {
//        case results = "movies"
//        case orderType = "order_type"
//    }
//}
//
//
//struct Movie: Codable {
//    let grade: Int
//    let thumnailImageURL: String
//    let reservationGrade: Int
//    let title: String
//    let reservationRate: Double
//    let userRating: Double
//    let date: String
//    let id: String
//
//    enum CodingKeys: String, CodingKey {
//        case grade, title, date, id
//        case thumnailImageURL = "thumb"
//        case reservationGrade = "reservation_grade"
//        case reservationRate = "reservation_rate"
//        case userRating = "user_rating"
//    }
//}
//
