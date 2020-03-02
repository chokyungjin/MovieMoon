//
//  APIConstants.swift
//  Mobo_iOS
//
//  Created by 천유정 on 24/12/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import Foundation

struct APIConstants {
    
    // 전역 변수로 사용할 수 있게 APIConstants 선언하여 사용

    static let BaseURL = "http://13.125.48.35:7935/"
    
    /* 유저(User) */
    static let LoginURL = BaseURL + "user/signIn" // 로그인
    static let SignupURL = BaseURL + "user/signUp" // 회원가입
    
    static let MatchingURL = BaseURL + "matching"
    static let MatchingConfirmURL = BaseURL + "matching/confirm"
    static let MatchingAddressURL = BaseURL + "matching/address"
    static let MatchingDecisionURL = BaseURL + "matching/decision"
    static let AutoMatchingURL = BaseURL + "matching/algorithm"
    static let MatchingDeleteURL = BaseURL + "matching/deleteall"
    
    static let MyPageURL = BaseURL + "mypage/info"
    static let MyPageHashURL = BaseURL + "mypage/info/hashtag"
    static let MyPageModifyURL = BaseURL + "mypage/info"
    static let MatchingPhotoURL = BaseURL + "mypage/info/photo"
    static let MatchingHashModifyURL = BaseURL + "mypage/info/hashtag"
    
    static let TicketURL = BaseURL + "mypage/ticket"
    static let TicketBuyURL = BaseURL + "mypage/ticket"
    static let TicketReduceURL = BaseURL + "/payment"
    
    static let MainViewURL = BaseURL + "main"
    
    static let BuySearchURL = BaseURL + "/movie/:movieReleaseStatus"
    
    

}

