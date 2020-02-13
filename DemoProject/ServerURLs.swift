//
//  ServerURLs.swift
//  boxoffice
//
//  Created by Cho on 16/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import Foundation

enum ServerURLs: String {
    case base = "http://connect-boxoffice.run.goorm.io"
    case movieList = "/movies?order_type="
    case movieDetail = "/movie?id="
    case movieComments = "/comments?movie_id="
}

struct APIConstants {
    // 전역 변수로 사용할 수 있게 APIConstants 선언하여 사용
    static let BaseURL = "http://54.180.186.62"
    
    //-user-
    //회원가입     POST /api/user
    //userId, password, nickname
    static let SignUpURL = BaseURL + "/api/user"
    //로그인         POST /api/user/login
    //userId, password
    static let LoginURL = BaseURL + "/api/user/login"

    //로그아웃        POST /api/user/logout
    static let LogoutURL = BaseURL + "/api/user/logout"

    //닉네임 변경     PATCH  /api/user/nickname
    //nickname
    //(로그인 상태만 가능)
    static let EditNickNameURL = BaseURL + "/api/user/nickname"
    //회원탈퇴     DELETE   /api/user/delete
    //userId
    //
    static let DeleteUserURL = BaseURL + "/api/user/delete"
    
    //프로필사진 업로드  POST    /api/user/image
    //image로 보내면 req.file로 받아지고, s3에 저장이 됨
    //여기서 req.file은 json형식인데 여기 안에 있는 경로를 따로 저장하고,
    //        PATCH    /api/user/image
    //위에서 저장한 경로를 src로 보내면 됨.
    //이미지는 한개만 전송가능
   
 //프로필사진 업로드  POST    /api/user/image
    static let ProfileImageURL = BaseURL + "/api/user/image"
    
    //-wishlist-
    //whshlist에서 나오는 모든 userId와 moveId는 각각의 user테이블과 movie테이블의 id값임(user테이블의 userId랑 혼동하면 통신 제대로 안됨)
    //위시리스트 불러오기    GET /api/wishlist
    //userId
    static let GetWishlistURL = BaseURL + "/api/wishlist"
    //위시리스트 등록        POST /api/wishlist
    //userId, movieId
    static let RegisterWishlistURL = BaseURL + "/api/wishlist"
    //위시리스트 삭제         DELETE /api/wishlist
    //userId, movieId
    static let DeleteWishlistURL = BaseURL + "/api/wishlist"

    //-boxoffice-
    //boxoffice에 있는 id 값은 movie의 id값과 무관함.
    //박스오피스 불러오기    GET    /api/boxoffice
    //year
    static let GetBoxofficeURL = BaseURL + "/api/boxoffice"
    
    //-search-
    //영화 검색        GET  /api/movie/searchbar
    //영화 제목으로만 검색
    //korTitle
    static let GetMovieTitleURL = BaseURL + "/api/movie/searchbar"
    //영화 상세검색         GET  /api/movie/detail
    //id(위의 검색에서 나온 movie의 id값)
    static let GetMovieDetailURL = BaseURL + "/api/movie/detail"

    //-diary-
    //wish와 거의 동일하게 userId와 moveId는 각각의 user테이블과 movie테이블의 id값임(user테이블의 userId랑 혼동하면 통신 제대로 안됨)
    //다이어리 리스트        GET /api/diary
    //userId
    static let GetDiaryURL = BaseURL + "/api/diary"
    //상세다이어리        GET /api/diary/detail
    //userId, movieId, diaryId
    static let GetDiaryDetailURL = BaseURL + "/api/diary/detail"
    //다이어리 등록        POST /api/diary
    //userId, movieId, memo, createDate
    static let RegisterDiaryURL = BaseURL + "/api/diary"
    //여기서 image는 위의 user랑 다른 점이 user은 이미지 한개만 받을 수 있는데 여기서의 이미지는 다중으로 받을 수 있고 이것의 주소 값이 200자로 제한되어있음. 밑에서 설명하겠음. 그리고 여기서의 이미지는 여러개를 받을 시에는 배열로 받으므로 배열의 경로값을 src로 입력을 해주면 됨.
    //다이어리 이미지 등록     POST /api/diary/image
    static let RegisterDiaryImageURL = BaseURL + "/api/diary/image"
    //여기서 이미지 값은 여러개이고 프론트에서 제한을 주면 좋겠음. 단 이미지의 경로의 길이가 있으므로 그것에 따라서 갯수 제한을 맞춰서 좋은데 5개 까지만 주면 좋겠음. 더 가능은 하지만 그 이상은 굳이?
    //여기서 받아오는 이미지는 req.files에서 v.location으로 받아 오게 됨 물론 입력은 image로 받아오고 이 값을 배열로 받아오게 되므로 이 배열에서 경로만을 저장해서 "","",""을 통해서 주는게 좋음.
    //만약에 여기서 3개로 제한을 주고 diaryimage의 테이블에서 3개로 나누어 주고 싶으면 그 때 수정을 하겠음.
    
    //다이어리 메모 수정        PATCH    /api/diary/memo
    //memo
    static let EditDiaryMemoURL = BaseURL + "/api/diary/memo"
    //다이어리 작성 날짜 수정     PATCH    /api/diary/createDate
    //createDate
    static let EditDiaryDateURL = BaseURL + "/api/diary/createDate"

    //다이어리 사진 수정         PATCH    /api/diary/image
    //image
    static let EditDiaryImageURL = BaseURL + "/api/diary/image"

    //다이어리 삭제        DELETE    /api/diayr
    //diaryId
    static let DeleteDiaryURL = BaseURL + "/api/diary"

}
