//
//  WishListModel.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/13.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

/// wishList Model
//{
//    "userId": "7",
//    "movieId": "135",
//    "poster": "http://file.koreafilm.or.kr/thm/02/00/00/95/tn_DPF000126.jpg",
//    "updatedAt": "2020-02-12T16:54:12.152Z",
//    "createdAt": "2020-02-12T16:54:12.152Z"
//}

struct WishListModel: Codable {

    var userId: Int
    var movieId: Int
    var poster: String? = nil
    var createdAt: String
    var updatedAt: String

}

struct MoviePoster: Codable {
    var poster : String? = nil
}


struct RecommendModel: Codable {

    var id : Int
    var userId: Int
    var movieId: Int
    var movie : MoviePoster
    
}

//{
//    "id": 1,
//    "userId": 14,
//    "movieId": 5154,
//    "movie": {
//        "poster": "http://file.koreafilm.or.kr/thm/02/00/04/07/tn_DPF011599.jpg"
//    }
//},
//{
//    "id": 2,
//    "userId": 14,
//    "movieId": 2388,
//    "movie": {
//        "poster": "http://file.koreafilm.or.kr/thm/02/00/00/98/tn_DPF000235.jpg"
//    }
//},
