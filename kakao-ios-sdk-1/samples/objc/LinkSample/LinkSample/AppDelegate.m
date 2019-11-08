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
#import <KakaoLink/KakaoLink.h>
#import "UIAlertController+Addition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[KLKTalkLinkCenter sharedCenter] isTalkLinkCallback:url]) {
        NSString *params = url.query;
        [UIAlertController showMessage:[NSString stringWithFormat:@"카카오링크 메시지 액션\n%@", params]];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[KLKTalkLinkCenter sharedCenter] isTalkLinkCallback:url]) {
        NSString *params = url.query;
        [UIAlertController showMessage:[NSString stringWithFormat:@"카카오링크 메시지 액션\n%@", params]];
        return YES;
    }
    return NO;
}

@end
