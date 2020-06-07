//
//  RecommendService.swift
//  DemoProject
//
//  Created by 조경진 on 2020/06/07.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation
import Alamofire

struct RecommendService {
    
    static let shared = RecommendService()
    
    func getRecommendList(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        
        //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
        Alamofire.request(APIConstants.GetRecommendlistURL, method: .get , headers: header).responseData(){ response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        print(status)
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                print(value)
                                let result = try decoder.decode([RecommendModel].self, from: value)
                                
                                completion(.success(result))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                                print(APIConstants.GetRecommendlistURL)
                            }
                        case 400:
                            completion(.requestErr("입력 값에 null이 존재합니다."))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
            
        }
        
    }
    
}
