//
//  boxOfficeModel.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/11.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation
//[
//    {
//        "id": 39,
//        "ranking": 9,
//        "korTitle": "미이라 3:황제의 무덤",
//        "releaseData": "20080730",
//        "sales": "26217311000",
//        "audience": 4090885,
//        "nation": "미국",
//        "producer": "유니버설픽쳐스인터내셔널 코리아(유)",
//        "year": 2008,
//        "poster": "http://file.koreafilm.or.kr/thm/02/00/01/08/tn_DPF000608.jpg"
//    },
//    {
//        "id": 40,
//        "ranking": 10,
//        "korTitle": "다크 나이트",
//        "releaseData": "20080806",
//        "sales": "26878184500",
//        "audience": 4060490,
//        "nation": "미국",
//        "producer": "주식회사 해리슨앤컴퍼니 워너브러더스 코리아(주)",
//        "year": 2008,
//        "poster": "http://file.koreafilm.or.kr/thm/02/00/01/08/tn_DPF000611.jpg"
//    }
//]

struct BoxOfficeModel : Codable {
    
    var id: Int
    var korTitle: String
    var ranking: Int
    var releaseDate: String
    var sales: String
    var audience: Int
    var nation: String
    var producer: String
    var year: Int
    var poster: String
    
}
