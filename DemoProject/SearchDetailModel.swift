//
//  SearchDetailModel.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/11.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

//{
//    "id": 4035,
//    "korTitle": "해리 2",
//    "genres": "드라마",
//    "releaseDate": "",
//    "age": "전체관람가",
//    "makingNation": "대한민국",
//    "poster": "http://file.koreafilm.or.kr/thm/02/00/02/60/tn_DPK008866.JPG",
//    "runninngtime": 68,
//    "director": "김동춘",
//    "actor": "\"김세민,윤선희\""
//}


struct SearchDetailModel: Codable {
    
    var id: Int
    var korTitle: String? = nil
    var genres: String? = nil
    var releaseDate: String? = nil
    var age: String? = nil
    var makingNation: String? = nil
    var poster: String? = nil
    var runningtime: Int? = nil
    var director: String? = nil
    var actor: String? = nil
    
}
