//
//  ResponseString.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/09.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

// MARK: - SignUpModel
//{
//    "userId": "jo",
//    "password": "0000",
//    "nickname" : "만두"
//}

// 성공했을 때 response body
struct SignUpModel: Codable {
    let userId: String
    let password: String
    let nickname: String
    
}

