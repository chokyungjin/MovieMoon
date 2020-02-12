//
//  NetworkResult.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/09.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation

// 네트워크 상태의 5가지 결과 (성공, 요청 에러, 경로 에러, 서버 에러, 통신 실패)
enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
    case dbErr
}
