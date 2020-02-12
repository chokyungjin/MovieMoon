//
//  SearchService.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/09.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation
import Alamofire

struct SearchService {
    
    static let shared = SearchService()
    
    // NetworkResult 파일에 통신 상태 5가지를 명시했었음 --> 이게 모델이 됨
    // @escaping에 명시한 모델을 반환하여 그에 따라 다르게 처리
    /**
     검색 통신 메소드
     **/
    
    func titleSearch(_ korTitle: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "korTitle" : korTitle
        ]
        
        //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
        Alamofire.request(APIConstants.GetMovieTitleURL, method: .get, parameters: body ,encoding: URLEncoding(destination: .queryString), headers: header).responseData(){ response in
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
                                print(APIConstants.GetMovieTitleURL)
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
    
    //http://54.180.186.62/api/movie/detail?id=4035

    func detailSearch(_ Id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
            
            let header: HTTPHeaders = [
                "Content-Type" : "application/json"
            ]
            let body: Parameters = [
                "id" : Id
            ]
            
            //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
        Alamofire.request(APIConstants.GetMovieDetailURL, method: .get, parameters: body ,encoding: URLEncoding(destination: .queryString), headers: header).responseData(){ response in
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
                                    let result = try decoder.decode(SearchDetailModel.self, from: value)
                                    completion(.success(result))
                                }
                                catch {
                                    completion(.pathErr)
                                    print(error.localizedDescription)
                                    print(APIConstants.GetMovieDetailURL)
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
    //http://54.180.186.62/api/boxoffice/?year=2008
    func boxOfficeSearch(_ year: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "year" : year
        ]
        
        //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
        Alamofire.request(APIConstants.GetBoxofficeURL, method: .get, parameters: body ,encoding: URLEncoding(destination: .queryString), headers: header).responseData(){ response in
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
                                let result = try decoder.decode([BoxOfficeModel].self, from: value)
                                completion(.success(result))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                                print(APIConstants.GetBoxofficeURL)
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
