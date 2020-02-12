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
