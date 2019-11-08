/**
 * Copyright 2015-2016 Kakao Corp.
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

#import "StoryProfileTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface StoryProfileTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@end

@implementation StoryProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setStoryProfile:(KOStoryProfile *)profile {
    if (profile == nil) {
        return;
    }
    
    if (profile.bgImageURL) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:profile.bgImageURL]];
    }
    
    if (profile.profileImageURL) {
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:profile.profileImageURL]
                                 placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"PlaceHolder"];
    }
    
    self.nickNameLabel.text = profile.nickName;
    self.birthdayLabel.text = [NSString stringWithFormat:@"%@ %@", profile.birthday, (profile.birthdayType == KOStoryProfileBirthdayTypeSolar ? @"SOLAR" : @"LUNAR")];
}

@end
