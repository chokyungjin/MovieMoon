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
 @header KNVLocation.h
 특정 장소에 대한 정보를 담고 있는 클래스. 목적지 또는 경유지로 사용된다.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class KNVLocation
 @abstract 특정 장소에 대한 정보를 담고 있는 클래스. 목적지 또는 경유지로 사용된다.
 */
@interface KNVLocation : NSObject <NSCopying, NSCoding>

/*!
 @property name
 @abstract 장소 이름. (required)
 */
@property (copy, nonatomic) NSString *name;

/*!
 @property x
 @abstract 장소의 경도 좌표. (required)
 */
@property (copy, nonatomic) NSNumber *x;

/*!
 @property y
 @abstract 장소의 위도 좌표. (required)
 */
@property (copy, nonatomic) NSNumber *y;


@property (nullable, copy, nonatomic) NSString *rpflag;
@property (nullable, copy, nonatomic) NSString *cid;

@end

@interface KNVLocation (Creation)

+ (instancetype)locationWithName:(NSString *)name x:(NSNumber *)x y:(NSNumber *)y;
- (instancetype)initWithName:(NSString *)name x:(NSNumber *)x y:(NSNumber *)y;

@end

NS_ASSUME_NONNULL_END
