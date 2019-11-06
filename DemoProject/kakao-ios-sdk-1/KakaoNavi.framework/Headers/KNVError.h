/**
 * Copyright 2017 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*!
 @header KNVError.h
 KakaoNavi API를 호출할 때 발생하는 오류들을 정의합니다.
 */
#import <KakaoCommon/KCMError.h>

/*!
 @constant KNVErrorDomain KakaoNavi API에서 발생하는 NSError 객체의 도메인.
 */
extern NSString *const KNVErrorDomain;

/*!
 @abstract KakaoNavi API에서 발생하는 오류 코드 정의
 @constant KNVErrorCodeUnknown 알 수 없는 오류
 @constant KNVErrorCodeNotSupported 지원되는 버전의 카카오내비(3.5)가 설치되어 있지 않음
 @constant KNVErrorCodeBadParameter 파라미터 이상
 @constant KNVErrorCodeMisconfigured 개발환경 설정 오류
 @constant KNVErrorCodeInternal SDK 내부 오류
 */
typedef NS_ENUM(NSInteger, KNVErrorCode)
{
    KNVErrorCodeUnknown = KCMErrorCodeUnknown,
    KNVErrorCodeNotSupported = KCMErrorCodeNotSupported,
    KNVErrorCodeBadParameter = KCMErrorCodeBadParameter,
    KNVErrorCodeMisconfigured = KCMErrorCodeMisconfigured,
    KNVErrorCodeInternal = KCMErrorCodeInternal,
};
