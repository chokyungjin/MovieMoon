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

#import "ThumbnailImageViewCell.h"

@implementation ThumbnailImageViewCell

const CGFloat kCellMargin = 12;

- (void)layoutSubviews {
    [super layoutSubviews];
 
    CGRect cellFrame = self.contentView.frame;
    CGFloat cellHeight = cellFrame.size.height;
    
    self.imageView.frame = CGRectMake(4, 1, cellHeight - 2, cellHeight - 2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizingMask = UIViewAutoresizingNone;
    
    CGRect imageViewFrame = self.imageView.frame;
    CGFloat labelOriginX = imageViewFrame.origin.x + imageViewFrame.size.width + kCellMargin;
    
    self.textLabel.frame = CGRectMake(labelOriginX, self.textLabel.frame.origin.y, cellFrame.size.width - labelOriginX - kCellMargin, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(labelOriginX, self.detailTextLabel.frame.origin.y, cellFrame.size.width - labelOriginX - kCellMargin, self.detailTextLabel.frame.size.height);
}

@end
