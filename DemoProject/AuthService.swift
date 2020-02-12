//
//  AuthService.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/09.
//  Copyright © 2020 조경진. All rights reserved.
//

import Foundation
import Alamofire

struct AuthService {
    
    static let shared = AuthService()
    
    
    // NetworkResult 파일에 통신 상태 5가지를 명시했었음 --> 이게 모델이 됨
    // @escaping에 명시한 모델을 반환하여 그에 따라 다르게 처리
    
    /**
     로그인 통신 메소드
     **/
    
    func login(_ userId: String, _ password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "userId" : userId,
            "password" : password
        ]
        
        Alamofire.request(APIConstants.LoginURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                // parameter 위치
                switch response.result {
                // 통신 성공 - 네트워크 연결
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            print(status)
                            switch status {
                            case 200:
                                do {
                                    //쿠키 넣어줌!!!
                                    let cookies = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies(for: URL(string:APIConstants.LoginURL)!)


                                    let decoder = JSONDecoder()
                                    print("!!!!!")
                                    let result = try decoder.decode(LoginModel.self, from: value)
//                                    print(result)
//                                    print(cookies)
                                    print("!!!!!")
                                    
                                    print("success")
                                    completion(.success(result))
                                }
                                catch {
                                    completion(.pathErr)
                                    print(error.localizedDescription)
                                    print(APIConstants.LoginURL)
                                }
                            case 400:
                                completion(.pathErr)
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
    } // func login
    
    
    /**
     회원가입 통신 메소드
     **/
    
    func signup(_ id: String, _ pw: String, _ nickname: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "userId" : id,
            "password" : pw,
            "nickname" : nickname
            
        ]
        
        Alamofire.request(APIConstants.SignUpURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
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
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    print(value)
                                    let result = try decoder.decode(SignUpModel.self, from: value)
                                    
                                    print("success")
                                    
                                    completion(.success(result))
                                }
                                catch {
                                    print("pathErr")
                                    completion(.pathErr)
                                    
                                }
                                
                            case 400:
                                print("400 pathERr")
                                completion(.pathErr)
                                
                            case 403:
                                print("이미 존재하는 아이디")
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
    
    //profile image post method..
    // 아마존s3에 post해놓고 저장경로를
    //patch /api/user/image에 req.body.src로 보내야함!
    
    func postImage(_ src: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "image" : src
        ]
        let imgData = src.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpeg")
            for (key, value) in body {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            } //Optional for extra parameters
        },
                         to:APIConstants.ProfileImageURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseData { response in
                    //                    completion(.success(response.result.value))
                    switch response.result {
                    // 통신 성공 - 네트워크 연결
                    case .success:
                        if let value = response.result.value {
                            if let status = response.response?.statusCode {
                                print(status)
                                switch status {
                                case 200:
                                    do {
                                        let decoder = JSONDecoder()
                                        let result = try decoder.decode(PostImageModel.self, from: value)
                                        print("post Image Success")
                                        completion(.success(result))
                                    }
                                    catch {
                                        completion(.pathErr)
                                        print(error.localizedDescription)
                                        print(APIConstants.ProfileImageURL)
                                    }
                                case 400:
                                    completion(.pathErr)
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
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
        
        
    } // func postImage
    
    func patchImage(_ src: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/formdata"
        ]
        
        let body: Parameters = [
            "src" : src
        ]
        
        Alamofire.request(APIConstants.ProfileImageURL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: header)
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
                            print(status) //200 출력
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    
                                    // 디코더에서 문제인듯
                                    // let result = try decoder.decode(PatchImageModel.self, from: value)
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
                                print("수정 실패!")
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
    } //func patch Image
    
    func patchNickname(_ nickname: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "nickname" : nickname
        ]
        
        Alamofire.request(APIConstants.EditNickNameURL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: header)
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
                            print(status) //200 출력
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    
                                    // let result = try decoder.decode(PatchImageModel.self, from: value)
                                    print("success")
                                    completion(.success("닉네임 변경 성공"))
                                }
                                catch {
                                    print("pathErr")
                                    completion(.pathErr)
                                    
                                }
                                
                            case 400:
                                print("400 pathERr")
                                completion(.pathErr)
                                
                            case 403:
                                print("수정 실패!")
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
    } //func patch Nickname
    
    
    
    
}
