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
 @header KNVNaviLauncher.h
 카카오내비 실행을 담당하는 클래스.
*/

#import <UIKit/UIKit.h>

@class KNVParams;

NS_ASSUME_NONNULL_BEGIN

/*!
 @typedef KNVNaviCompletionHandler
 @abstract 카카오내비 실행이 완료될 때 호출되는 콜백.
 @param error 실행 도중 발생한 에러.
 */
typedef void(^KNVNaviCompletionHandler)(NSError *_Nullable error);

/*!
 @class KNVNaviLauncher
 @abstract 카카오내비 실행을 담당하는 클래스.
 */
@interface KNVNaviLauncher : NSObject

/*!
 @property appStoreURL
 @abstract 카카오내비 앱스토어 URL
 */
@property (readonly, class) NSURL *appStoreURL;

/*!
 @property enableWebNavi
 @abstract 카카오내비가 설치되어 있지 않을 때 web 길안내 사용 여부. NO로 설정하면 AppStore로 이동함. default YES.
 */
@property (nonatomic, assign, getter=isEnableWebNavi) BOOL enableWebNavi;

/*!
 @property presentingViewController
 @abstract 길안내 web view 가 present 될 뷰컨트롤러를 설정. 설정하지 않을 경우 자체적으로 최상단 뷰컨트롤러를 탐색하여 present 함.
 */
@property (nonatomic, weak, nullable) UIViewController *presentingViewController;

/*!
 @property presentedViewStatusBarStyle
 @abstract 길안내 web view 가 실행되는 동안의 status bar 스타일. 길안내가 종료되면 이전 스타일로 되돌아 감.
 */
@property (nonatomic, assign) UIStatusBarStyle presentedViewStatusBarStyle;

/*!
 @property presentedViewBarTitleColor
 @abstract 길안내 web view 화면의 상단 바 title 색상.
 */
@property (nonatomic, strong, nullable) UIColor *presentedViewBarTitleColor;

/*!
 @property presentedViewBarTintColor
 @abstract 길안내 web view 화면의 상단 바 배경색. presentedViewBarBackgroundImage가 설정될 경우 이 속성은 무시 됨.
 */
@property (nonatomic, strong, nullable) UIColor *presentedViewBarTintColor;

/*!
 @property presentedViewBarButtonTintColor
 @abstract 길안내 web view 화면의 상단 바 버튼 색상.
 */
@property (nonatomic, strong, nullable) UIColor *presentedViewBarButtonTintColor;

/*!
 @property presentedViewBarBackgroundImage
 @abstract 길안내 web view 화면의 상단 바 배경 이미지. 배경 이미지를 설정하면 presentedViewBarTintColor는 무시 됨.
 */
@property (nonatomic, strong, nullable) UIImage *presentedViewBarBackgroundImage;

/*!
 카카오내비 실행을 담당하는 singleton 인스턴스
 */
+ (nonnull instancetype)sharedLauncher;

/*!
 @method canOpenKakaoNavi
 @abstract 카카오내비 앱이 실행 가능한지 여부를 리턴합니다.
 */
- (BOOL)canOpenKakaoNavi;

/*!
 @method shareDestinationWithParams:completion:
 @abstract 카카오내비 앱을 호출하여 목적지를 공유합니댜. 카카오내비 앱이 실행되면 공유한 목적지의 상세화면이 노출됩니다. web 길안내로 실행될 경우 목적지 공유 상세화면 없이 바로 길안내가 시작됩니다.
 @param params 목적지 공유에 필요한 파라미터. (required)
 @param completion 카카오내비 실행 완료 또는 웹 길안내 노출 시 호출되는 완료 핸들러.
 */
- (void)shareDestinationWithParams:(KNVParams *)params completion:(nullable KNVNaviCompletionHandler)completion;

- (void)shareDestinationWithParams:(KNVParams *)params error:(NSError * _Nullable * _Nullable)error DEPRECATED_ATTRIBUTE;

/*!
 @method navigateWithParams:error:
 @abstract 카카오내비 앱을 호출하여 목적지까지 길안내를 실행합니다.
 @param params 목적지 길안내에 필요한 파라미터. (required)
 @param completion 카카오내비 실행 완료 또는 웹 길안내 노출 시 호출되는 완료 핸들러.
 */
- (void)navigateWithParams:(KNVParams *)params completion:(nullable KNVNaviCompletionHandler)completion;

- (void)navigateWithParams:(KNVParams *)params error:(NSError * _Nullable * _Nullable)error DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
