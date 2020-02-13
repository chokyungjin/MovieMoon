//
//  DiaryService.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/12.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation
import Alamofire


struct DiaryService {
    
    static let shared = DiaryService()
    
    func diaryPost(_ userId: Int, _ movieId: String, _ memo: String, _ createDate: String  ,completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "userId" : userId,
            "movieId" : movieId,
            "memo" : memo,
            "createDate" : createDate
        ]
        
        Alamofire.request(APIConstants.RegisterDiaryURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                // parameter 위치
                switch response.result {
                    
                // 통신 성공 - 네트워크 연결
                case .success:
                    if let value = response.result.value {
                        
                        // 서버가 보내는 http Header에 담긴 status code
                        // Rest API에서 통신을 성공했던 실패했던 네트워크 통신이 성공했기 때문에 발생
                        // 서버가 예측한 질문에 대해 응답이 왔다면 200 status code
                        // 이제부터 서버 개발자가 분기할 코드에 대해 작성함 ex) 택배와 택배기사
                        if let status = response.response?.statusCode {
                            print(status)
                            switch status {
                            case 201:
                                do {
                                    let decoder = JSONDecoder()
                                    print(value)
//                                    let result = try decoder.decode(SignUpModel.self, from: value)
                                    
                                    print("success")
                                    
                                    completion(.success("SUCCESS"))
                                }
                                catch {
                                    print("pathErr")
                                    completion(.pathErr)
                                    
                                }
                                
                            case 400:
                                print("400 pathERr")
                                completion(.pathErr)
                                
                            case 403:
                                print("이미 존재하는 다이어리입니다.")
                                completion(.requestErr((Any).self))
                            case 500:
                                print("500 pathERr")
                                completion(.serverErr)
                            case 600:
                                print("600 pathErr")
                                completion(.dbErr)
                            default:
                                print("default")
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
    
    func getDiary(completion: @escaping (NetworkResult<Any>) -> Void) {
            
            let header: HTTPHeaders = [
                "Content-Type" : "application/json"
            ]
            
            //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
        Alamofire.request(APIConstants.GetDiaryURL, method: .get ,encoding: URLEncoding(destination: .queryString)).responseData(){ response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            print(status)
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
    //                                print(value)
                                    let result = try decoder.decode([DiaryGetList].self, from: value)
                                    
                                    completion(.success(result))
                                }
                                catch {
                                    completion(.pathErr)
                                    print(error.localizedDescription)
                                    print(APIConstants.GetDiaryURL)
                                }
                            case 400:
                                completion(.requestErr("해당 아이디 다시보세여."))
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
            
        } //DiaryGet
    
    
    //http://54.180.186.62/api/diary/detail?movieId=4&diaryId=135
    //다이어리 디테일 통신
    
    func diaryDetail(_ diaryid: Int, _ movieId: Int ,  completion: @escaping (NetworkResult<Any>) -> Void) {
            
            let header: HTTPHeaders = [
                "Content-Type" : "application/json"
            ]
            let body: Parameters = [
                "diaryid" : diaryid,
                "movieId" : movieId
            ]
            
            //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
            Alamofire.request(APIConstants.GetDiaryDetailURL, method: .get, parameters: body ,encoding: URLEncoding(destination: .queryString)).responseData(){ response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            print(status)
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
    //                                print(value)
                                    let result = try decoder.decode([SearchTitleModel].self, from: value)
                                    
                                    completion(.success(result))
                                }
                                catch {
                                    completion(.pathErr)
                                    print(error.localizedDescription)
                                    print(APIConstants.GetDiaryDetailURL)
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