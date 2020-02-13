//
//  ResponseString.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/09.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

// MARK: - ResponseString
//{
//    "id": 7,
//    "userId": "cho",
//    "nickname": "조경진",
//    "src": null,
//    "createdAt": "2020-02-09T08:15:19.000Z",
//    "updatedAt": "2020-02-09T08:15:19.000Z"}

// 성공했을 때 response body
struct LoginModel: Codable {
    var id: Int
    var userId: String
    var nickname: String
    var src: String? = nil
    var createdAt: String
    var updatedAt: String
    
}

