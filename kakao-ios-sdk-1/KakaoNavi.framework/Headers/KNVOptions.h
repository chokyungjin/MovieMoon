/**
 * Copyright 2016 Kakao Corp.
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
 @header KNVOptions.h
 길안내 API의 옵션 설정을 담고 있는 클래스.
 */

#import <Foundation/Foundation.h>

/*!
 @abstract KNVCoordType 좌표타입 (모든 좌표 속성은 이 좌표타입으로 취급한다.)
 @constant KNVCoordTypeKATEC KATEC 좌표계.
 @constant KNVCoordTypeWGS84 WGS84 좌표계.
 */
typedef NS_ENUM(NSUInteger, KNVCoordType) {
    KNVCoordTypeKATEC = 1,
    KNVCoordTypeWGS84 = 2,
};

/*!
 @abstract KNVVehicleType 차종(1~7)
 @constant KNVVehicleTypeFirst 1종(승용차/소형승합차/소형화물화)
 @constant KNVVehicleTypeSecond 2종(중형승합차/중형화물차)
 @constant KNVVehicleTypeThird 3종(대형승합차/2축 대형화물차)
 @constant KNVVehicleTypeFourth 4종(3축 대형화물차)
 @constant KNVVehicleTypeFifth 5종(4축이상 특수화물차)
 @constant KNVVehicleTypeSixth 6종(경차)
 @constant KNVVehicleTypeTwoWheel 이륜차
 */
typedef NS_ENUM(NSUInteger, KNVVehicleType) {
    KNVVehicleTypeFirst = 1,
    KNVVehicleTypeSecond = 2,
    KNVVehicleTypeThird = 3,
    KNVVehicleTypeFourth = 4,
    KNVVehicleTypeFifth = 5,
    KNVVehicleTypeSixth = 6,
    KNVVehicleTypeTwoWheel = 7,
};

/*!
 @abstract KNVRpOption 경로옵션
 @constant KNVRpOptionFast 빠른길
 @constant KNVRpOptionFree 무료도로
 @constant KNVRpOptionShortest 최단거리
 @constant KNVRpOptionNoAuto 자동차전용제외
 @constant KNVRpOptionWide Wide
 @constant KNVRpOptionHighway Highway
 @constant KNVRpOptionNormal Normal
 @constant KNVRpOptionRecommended 추천경로 (기본값)
 */
typedef NS_ENUM(NSUInteger, KNVRpOption) {
    KNVRpOptionFast = 1,
    KNVRpOptionFree = 2,
    KNVRpOptionShortest = 3,
    KNVRpOptionNoAuto = 4,
    KNVRpOptionWide = 5,
    KNVRpOptionHighway = 6,
    KNVRpOptionNormal = 8,
    KNVRpOptionRecommended = 100,
};

/*!
 @class KNVOptions
 @abstract 길안내 API의 옵션 설정을 담고 있는 클래스.
 */
@interface KNVOptions : NSObject <NSCopying, NSCoding>

/*!
 @property coordType
 @abstract 좌표타입.
 */
@property (assign, nonatomic) KNVCoordType coordType;

/*!
 @property vehicleType
 @abstract 차종.
 */
@property (assign, nonatomic) KNVVehicleType vehicleType;

/*!
 @property rpOption
 @abstract 경로옵션.
 */
@property (assign, nonatomic) KNVRpOption rpOption;

/*!
 @property routeInfo
 @abstract 전체 경로정보 보기 여부.
 */
@property (assign, nonatomic) BOOL routeInfo;

/*!
 @property startX
 @abstract 시작위치의 경도 좌표.
 */
@property (nullable, copy, nonatomic) NSNumber *startX;

/*!
 @property startY
 @abstract 시작위치의 경도 좌표.
 */
@property (nullable, copy, nonatomic) NSNumber *startY;

/*!
 @property startAngle
 @abstract 시작 앵글 (0~359). 앵글을 설정하지 않을 경우: -1
 */
@property (nullable, copy, nonatomic) NSNumber *startAngle;

/*!
 @property userId
 @abstract 길안내 유저 구분을 위한 USER ID. (현재 택시에서 사용)
 */
@property (nullable, copy, nonatomic) NSString *userId;

/*!
 @property returnUri
 @abstract 길안내 종료(전체 경로보기시 종료) 후 호출 될 URI.
 */
@property (nullable, copy, nonatomic) NSString *returnUri;

@end

@interface KNVOptions (Creation)

+ (nonnull instancetype)options;

@end
