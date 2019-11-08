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

#import "LoginViewController.h"
#import "UIButton+Addition.h"
#import "UIAlertController+Addition.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@implementation LoginViewController

- (IBAction)login:(id)sender {
    KOSession *session = [KOSession sharedSession];
    
    if (session.isOpen) {
        [session close];
    }
    
    [session openWithCompletionHandler:^(NSError *error) {
        if (!session.isOpen) {
            switch (error.code) {
                case KOErrorCancelled:
                    break;
                default:
                    [UIAlertController showMessage:error.description];
                    break;
            }
        }
    }];
}

@end
