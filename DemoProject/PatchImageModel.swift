//
//  ResponseString.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/09.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

// MARK: - PatchImageModel
//{
//프로필 사진 등록 완료!
//}

// 성공했을 때 response body
struct PatchImageModel: Codable {
    let message: String
}

