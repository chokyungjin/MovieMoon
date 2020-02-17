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
    
    func diaryPost(_ userId: Int, _ movieId: String, _ memo: String, _ createDate: String ,_ src: [String] ,completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "userId" : userId,
            "movieId" : movieId,
            "memo" : memo,
            "createDate" : createDate,
            "image": src
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
                                    // let decoder = JSONDecoder()
                                    print(value)
                                    // let result = try decoder.decode(SignUpModel.self, from: value)
                                    
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
        
        //            let header: HTTPHeaders = [
        //                "Content-Type" : "application/json"
        //            ]
        
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
    
    //다이어리 디테일 통신
    func diaryDetail(_ diaryId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "diaryId" : diaryId
        ]
        
        //body에 인자 넣어줄때는 encoding = default , query로 전달할땐 encoding = queryString
        Alamofire.request(APIConstants.GetDiaryDetailURL, method: .get, parameters: body ,encoding: URLEncoding(destination: .queryString), headers: header).responseData(){ response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        print(status)
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                //print(value)
                                //                                    print(String(data: value, encoding: .utf8))
                                let result = try! decoder.decode(DiaryDetailModel.self, from: value)
                                
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
    
    //memo 변경
    func patchMemo(_ memo: String ,_ userId: Int ,_ movieId : Int , completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "memo" : memo,
            "userId" : userId,
            "movieId" : movieId
        ]
        
        Alamofire.request(APIConstants.EditDiaryMemoURL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: header)
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
                                    
                                    print(String(data: value, encoding: .utf8) ?? "파싱 중 입니다.")
                                    // let result = try decoder.decode(PatchImageModel.self, from: value)
                                    print("success")
                                    completion(.success("메모 변경 성공"))
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
    } //func patch memo
    
    func patchcreateDate(_ createDate: String ,_ userId: Int ,_ movieId : Int , completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "createDate" : createDate,
            "userId" : userId,
            "movieId" : movieId
        ]
        
        Alamofire.request(APIConstants.EditDiaryDateURL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                // parameter 위치
                switch response.result {
                    
                // 통신 성공 - 네트워크 연결
                case .success:
                    if let value = response.result.value {
                        
                        if let status = response.response?.statusCode {
                            print(status) //200 출력
                            switch status {
                            case 200:
                                do {
                                    // let decoder = JSONDecoder()
                                    // let result = try decoder.decode(PatchImageModel.self, from: value)
                                    print("success")
                                    completion(.success("날짜 변경 성공"))
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
    } //func patch Date
    
    func postImage(_ image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void) {
        
//        let header: HTTPHeaders = [
//            "Content-Type" : "application/json"
//        ]
        let body: Parameters = [
            "image" : image
        ]
        let imgData1 = image[0].jpegData(compressionQuality: 0.2) ?? UIImage(named: "img_placeholder")?.jpegData(compressionQuality: 0.2)
        let imgData2 = image[1].jpegData(compressionQuality: 0.2) ?? UIImage(named: "img_placeholder")?.jpegData(compressionQuality: 0.2)!
         let imgData3 = image[2].jpegData(compressionQuality: 0.2) ?? UIImage(named: "img_placeholder")?.jpegData(compressionQuality: 0.2)
                
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData1!, withName: "image",fileName: "file.jpg", mimeType: "image/jpeg" )
            multipartFormData.append(imgData2!, withName: "image",fileName: "file.jpg", mimeType: "image/jpeg" )
            multipartFormData.append(imgData3!, withName: "image",fileName: "file.jpg", mimeType: "image/jpeg" )

            for (key, value) in body {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            } //Optional for extra parameters
        },
                         to:APIConstants.RegisterDiaryImageURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseData { response in
                    switch response.result {
                    // 통신 성공 - 네트워크 연결
                    case .success:
                        if let value = response.result.value {
                            if let status = response.response?.statusCode {
                                print(status)
                                switch status {
                                case 200:
                                    do {
                                        //이미지 올리는데 디코딩으로 되어있지 않음!!
                                         let decoder = JSONDecoder()
                                        let result = try decoder.decode([String].self, from: value)
                                        
                                        print("post Image Success")
                                        completion(.success(result))
                                    }
                                    catch {
                                        completion(.pathErr)
                                        print(error.localizedDescription)
                                        print(APIConstants.RegisterDiaryImageURL)
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
    
    
    func patchImage(_ image: String , _ diaryId: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "image" : image,
            "diaryId" : diaryId
        ]
        
        Alamofire.request(APIConstants.EditDiaryImageURL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                // parameter 위치
                switch response.result {
                    
                // 통신 성공 - 네트워크 연결
                case .success:
                    if let value = response.result.value {
                        
                        
                        if let status = response.response?.statusCode {
                            print(status) //200 출력
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    
                                    // 디코더에서 문제인듯
                                    
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
    
    func deleteDiary(_ diaryId : Int , completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "diaryId" : diaryId
        ]
        
        Alamofire.request(APIConstants.DeleteDiaryURL, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                // parameter 위치
                switch response.result {
                    
                // 통신 성공 - 네트워크 연결
                case .success:
                    if let value = response.result.value {
                        
                        if let status = response.response?.statusCode {
                            print(status) //201 출력
                            switch status {
                            case 201:
                                do {
                                    // let decoder = JSONDecoder()
                                    // let result = try decoder.decode(PatchImageModel.self, from: value)
                                    print("success")
                                    completion(.success("다이어리 삭제 성공"))
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
    } //func patch Date
    
    
}
