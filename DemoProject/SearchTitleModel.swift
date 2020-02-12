//
//  MovieSearchModel.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/11.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

//[
//    {
//        "korTitle": "해리 포터와 불사조 기사단",
//        "genres": "\"액션,어드벤처,가족,판타지\"",
//        "releaseDate": "20070712",
//        "makingNation": "\"영국,미국\"",
//        "poster": "http://file.koreafilm.or.kr/thm/02/00/00/95/tn_DPF000126.jpg",
//        "id": 135
//    },
//    {
//        "korTitle": "해리 포터와 마법사의 돌",
//        "genres": "\"드라마,어드벤처,가족,판타지\"",
//        "releaseDate": "20011214",
//        "makingNation": "미국",
//        "poster": "http://file.koreafilm.or.kr/thm/02/00/02/94/tn_DPF008206.JPG",
//        "id": 5268
//    }
//]

// MARK: - SearchTitleModel
// 성공했을 때 response body
struct SearchTitleModel: Codable {
    var korTitle: String? = nil
    var genres: String? = nil
    var releaseDate: String? = nil
    var makingNation: String? = nil
    var poster: String? = nil
    var id: Int
    
}
