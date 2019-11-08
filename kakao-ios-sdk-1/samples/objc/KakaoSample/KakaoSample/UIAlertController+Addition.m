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

#import "UIAlertController+Addition.h"

@implementation UIAlertController (Addition)

+ (void)showMessage:(NSString *)message {
    [self showAlertWithTitle:@"" message:message actions:@[[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:nil]]];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (UIAlertAction *action in actions) {
            [alert addAction:action];
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

@end
