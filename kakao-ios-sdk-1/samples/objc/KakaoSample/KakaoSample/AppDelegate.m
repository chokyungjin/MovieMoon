/**
 * Copyright 2015-2018 Kakao Corp.
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

#import "AppDelegate.h"
#import "ConfigConstants.h"
#import "UIAlertController+Addition.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *loginViewController;
@property (nonatomic, strong) UINavigationController *mainViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupEntryController];
    
    // 로그인,로그아웃 상태 변경 받기
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kakaoSessionDidChangeWithNotification)
                                                 name:KOSessionDidChangeNotification
                                               object:nil];
    
    // 클라이언트 시크릿 설정
    [KOSession sharedSession].clientSecret = SESSION_CLIENT_SECRET;
    
    [self reloadRootViewController];
    
    return YES;
}

- (void)setupEntryController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"navigator"];
    self.mainViewController = [storyBoard instantiateViewControllerWithIdentifier:@"navigator"];
    
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"login"];
    [self.loginViewController pushViewController:viewController animated:YES];
    
    UIViewController *viewController2 = [storyBoard instantiateViewControllerWithIdentifier:@"main"];
    [self.mainViewController pushViewController:viewController2 animated:YES];
}

- (void)reloadRootViewController {
    BOOL isOpened = [KOSession sharedSession].isOpen;
    
    if (!isOpened) {
        [self.mainViewController popToRootViewControllerAnimated:YES];
    }
    
    self.window.rootViewController = isOpened ? self.mainViewController : self.loginViewController;
    [self.window makeKeyAndVisible];
}

- (void)kakaoSessionDidChangeWithNotification {
    [self reloadRootViewController];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([KOSession handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([KOSession handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [KOSession handleDidEnterBackground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [KOSession handleDidBecomeActive];
}

@end
