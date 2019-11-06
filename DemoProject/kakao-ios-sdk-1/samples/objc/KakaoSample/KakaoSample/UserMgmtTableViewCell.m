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

#import "UserMgmtTableViewCell.h"
#import "InsetableTextField.h"
#import "UIImageView+WebCache.h"

@interface UserMgmtTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet InsetableTextField *name;
@property (weak, nonatomic) IBOutlet InsetableTextField *nickName;
@property (weak, nonatomic) IBOutlet InsetableTextField *age;
@property (weak, nonatomic) IBOutlet InsetableTextField *gender;

@end

@implementation UserMgmtTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.name.inset = self.nickName.inset = self.age.inset = self.gender.inset = 10;
}

- (void)setMe:(KOUserMe *)me {
    if (me == nil) {
        return;
    }
    
    if (me.account.email) {
        self.email.text = me.account.email;
    } else if (me.account.emailNeedsAgreement == YES) {
        self.email.text = @"이메일 있음 (사용자 동의가 필요함)";
    } else {
        self.email.text = @"이메일 없음";
    }
    
    if (me.account.phoneNumber) {
        self.phoneNumber.text = me.account.phoneNumber;
    } else if (me.account.phoneNumberNeedsAgreement == YES) {
        self.phoneNumber.text = @"전화번호 있음 (사용자 동의가 필요함)";
    } else {
        self.phoneNumber.text = @"전화번호 없음";
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.thumbnail sd_setImageWithURL:me.thumbnailImageURL
                          placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    } else {
        [self.thumbnail sd_setImageWithURL:me.profileImageURL
                          placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    }
    
    self.nickName.text = me.nickname;
    
    self.name.text = me.properties[@"name"];
    self.age.text = me.properties[@"age"];
    self.gender.text = me.properties[@"gender"];
}

- (NSDictionary *)userDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:4];
    if (self.name.text) {
        dictionary[@"name"] = self.name.text;
    }
    if (self.nickName.text) {
        dictionary[@"nickname"] = self.nickName.text;
    }
    if (self.age.text) {
        dictionary[@"age"] = self.age.text;
    }
    if (self.gender.text) {
        dictionary[@"gender"] = self.gender.text;
    }
    return dictionary;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
