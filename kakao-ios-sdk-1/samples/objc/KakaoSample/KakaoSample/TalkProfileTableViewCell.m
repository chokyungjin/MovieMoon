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

#import "TalkProfileTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface TalkProfileTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *countryISO;

@end

@implementation TalkProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTalkProfile:(KOTalkProfile *)profile {
    if (profile == nil) {
        return;
    }
    
    if (profile.thumbnailURL) {
        [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:profile.thumbnailURL]
                          placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    } else {
        self.thumbnail.image = [UIImage imageNamed:@"PlaceHolder"];
    }
    
    self.nickName.text = profile.nickName;
    self.countryISO.text = profile.countryISO;
}

@end
